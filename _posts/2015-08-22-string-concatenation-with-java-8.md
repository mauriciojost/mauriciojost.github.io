---
layout: post
title: String concatenation with Java 8
comments: true
tags:
- Java
- String Concatenation
- Dynamic String Concatenation
- Static String Concatenation
- StringBuilder
- StringBuffer
- Javap
- JIT
- Just-In-Time compiler
- JMH
---

String concatenation is one of the most well known caveat in Java. Almost all experienced Java developpers have already heard or read explanations about when to use _String_ vs _StringBuilder_/_StringBuffer_ for concatenating Strings.

These last months I gave some interviews for a Java position in the company where I work. One of the exercices that candidate sometimes have to work on requires to concatenate Strings in a for loop. Obviously, as a ~~pervert~~ programmer, I like to ask people what they think about the performance of the code they write and how it could be improved. The answers were really surprising, especially about String concatenation. Although some explanations were not really convincing, they let me doubt whether using _StringBuilder_/_StringBuffer_ is still required with a recent Java virtual machine.  For this reason, I decided to do some investigations.

<!--more-->

# Understanding the issue

In Java String objects are immutable. It means that any operation on a String object will not alter the content of the object but create a new one with the transformed value.

```java
String result = "";
for (int i=0; i<1e6; i++) {
    result += "some more data";
}
```

For instance, the piece of code introduced above is a simple loop that iterates 1M times and concatenates the String "some more data" to the _result_ variable at each iteration. However, using the _+_ operator (which is strictly equivalent to _result = result + "some more data"_ in our example) or even [String#concat(String)](http://docs.oracle.com/javase/8/docs/api/java/lang/String.html#concat-java.lang.String-) does not mean that internally data are sticked at the end of the _result_ variable in one step. It is not possible since String objects are immutable.

Under the hood, many operations occur. First, a new array of characters is allocated with a size that fits the existing value contained by the _result_ variable but also the payload that is appended. Then, their value is copied to the new array instance and a new String object is created from the array. Finally, the new String instance replaces the one already assigned to the _result_ variable and this last is marked for [garbage collection](http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html) since it is not longer referenced by a variable.  

This sequence of actions means that as the _result_ variable grows, the amount of data to copy each time grows and the time to complete the operation too. Simple mathematics can be applied to estimate the complexity of the previous piece of code in terms of copy required.

At the first iteration, $14$ characters are copied to an array of characters of size $0 + 14$. The second iteration copies $28$ characters to an array of characters of size $14 + 14$. Then, at the third iteration, an array of size $28 + 14$ is allocated and $36$ characters copied into, and so on and so forth.

In summary, the number of copy required for _n_ iterations is equals to:

$$\sum_{i=0}^{n-1} 14 \times i = 7n(n-1) = 7n^2-7n$$

If you already took a complexity class, you probably remember that $7n^2-7n$ means that your algorithm complexity is in $O(n^2)$, namely quadratic.

# StringBuilder/StringBuffer to the rescue

As explained previously, the complexity of a simple Java loop concatenating Strings using the "+" operator is quadratic. That's not good, especially for a simple operation such as concatenation. Let's say that copying 10 characters takes 10ms, then it means that copying 100 characters will take 1s. In other words, a problem 10 times larger takes 100 times more work.

Hopefully, a solution to this issue exists. It consists in using the [StringBuilder](http://docs.oracle.com/javase/8/docs/api/java/lang/StringBuilder.html) or [StringBuffer](http://docs.oracle.com/javase/8/docs/api/java/lang/StringBuffer.html) class. The main difference between both is that the last is [thread-safe](https://en.wikipedia.org/wiki/Thread_safety) whereas the first is not. Below is an example solving the issue explained previously:

```java
StringBuilder result = new StringBuilder();
for (int i=0; i<1e6; i++) {
    result.append("some more data");
}
```

You can see an instance of _StringBuilder_/_StringBuffer_ like a mutable String object. The _append_ call alters the state of the object, thus avoiding several copies.

Internally, _StringBuilder_ makes use of a resizable array and an index that indicates the position of the last cell used in the array. When a new String is appended, its characters are copied to the end of the array and the index shifted to the right. If the internal array is full, its size is doubled (to be exact, if the array size is $x$, then the new size will be [$2x+2$](http://hg.openjdk.java.net/jdk8u/jdk8u/jdk/file/e52f33586140/src/share/classes/java/lang/AbstractStringBuilder.java#l128)).

So, why is this manner to proceed faster than the one used with the _+_ operator? The reason lies in the fact that array expansion and the associated copy of characters is performed occasionally, when the array is full. Asymptotically speaking, by using $2x+2$ as an expansion factor, the resize operation does not occur so often and StringBuilder#append(String) thus [takes O(1) amortized time](http://www.quora.com/What-is-the-complexity-of-Java-StringBuffer-append). Consequently, the whole loop has a complexity in $O(n)$.

# Looking at the Bytecode

What I explained is maybe boring but an interesting question is _does the previous explanations still hold with Java 8_? I mean is it still required to use _StringBuilder_/_StringBuffer_ or some magic tricks are applied with the _+_ operator? since going in deep in the [source code of JDK 8](http://hg.openjdk.java.net/jdk8u/jdk8u/jdk/file/) would require a few weeks, an alternative to answer the question is to look at the bytecode generated by the compiler.

Let's start with a simple example:

```java
public class StaticStringConcatenation {
    public static void main(String[] args) {
        String result = "";
        result += "some more data";
        System.out.println(result);
    }
}
```

An human readable representation of the bytecode that is generated by _javac_ can be obtained for the Java class above. It requires first to generate the class file associated to the source code, then to disassemble this last file using the _javap_ command. Since the previous code, along with all others resources introduced in this post are available on Github in a [dedicated Gradle project](https://github.com/lpellegr/experiments/tree/master/java/string-concatenation), both steps can be reproduced as follows once the project has been cloned:

```java
$ ./gradlew build &>-
$ javap -c ./build/classes/main/StaticStringConcatenation.class
Compiled from "StaticStringConcatenation.java"
public class StaticStringConcatenation {
  public StaticStringConcatenation();
    Code:
       0: aload_0          // Push 'this' on to the stack
       1: invokespecial #1 // Invoke Object class constructor
                           // pop 'this' ref from the stack
       4: return           // Return from constructor

  public static void main(java.lang.String[]);
    Code:
       0: ldc           #2 // Load constant #2 on to the stack
       2: astore_1         // Create local var from stack (pop #2)
       3: new           #3 // Push new StringBuilder ref on stack
       6: dup              // Duplicate value on top of the stack
       7: invokespecial #4 // Invoke StringBuilder constructor
                           // pop object reference
      10: aload_1          // Push local variable containing #2
      11: invokevirtual #5 // Invoke method StringBuilder.append()
                           // pop obj reference + parameter
                           // push result (StringBuilder ref)
      14: ldc           #6 // Push "some more data" on the stack
      16: invokevirtual #5 // Invoke StringBuilder.append
                           // pop twice, push result
      19: invokevirtual #7 // Invoke StringBuilder.toString:();
      22: astore_1         // Create local var from stack (pop #6)
      23: getstatic     #8 // Push value System.out:PrintStream
      26: aload_1          // Push local variable containing #6
      27: invokevirtual #9 // Invoke method PrintStream.println()
                           // pop twice (object ref + parameter)
      30: return           // Return void from method
}
```

In the output above, comments have been manually edited to get a text that fits in the page but also to clarify the bytecode [instructions](https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings). In consequence, it's normal if you get more obscure comment messages when you try to execute the previous commands.

Before continuing, some explanations about the JVM internals are required. The Java Virtual Machine (JVM) is an abstract machine that provides a runtime environment in which Java bytecode can be executed. To this aim, the JVM is [made of several components](http://blog.jamesdbloom.com/JVMInternals.html) including among others:

  - an _Operand Stack_ (named _stack_ in the following) that aims to execute bytecode instructions similarly to registers with a CPU;
  - a _Run Time Constant Pool_ (referred to as _constant pool_ below) to maintain a per-type constant pool;
  - a _Heap_ that is used to allocate class instances and arrays at runtime.

The output produced by _javap_ displays the bytecode instructions using JVM opcodes ([mnemonics](https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-6.html#jvms-6.4-mnemonic) to be exact). For instance, _aload\_0_ is the first opcode executed when the constructor of the class _StaticStringConcatenation_ is invoked. Its purpose is to push 'this' (the reference to the local object created in the heap) on to the stack. Then, _[invokespecial](https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-6.html#jvms-6.5.invokespecial)_  invokes the instance initialization method based on the object reference in the stack (and thus pop the reference from the stack to consume it). The exact class and method to execute is identified in this example by _#1_ in the constant pool. Constant pool values associated to an identifier can be displayed with the `-v` option of `javap`. Finally, _return_ terminates the execution of the constructor.

In summary, the JVM makes use of opcodes to execute basic instructions. The execution and pipelining of several instructions is made possible through an intermediary which is the stack. Values are pushed to and/or pop from when opcodes are executed.

Now, let's take a look at the instructions and their associated comments for the _main_ method. At code _7_, a new instance of _StringBuilder_ is created, then at code _11_ the empty String is appended to the _StringBuilder_ object by using the append method. Similarly, at code _16_ the String "some more data" is concatenated before retrieving a String representation with the help of the _toString_ method (code 19). Finally, once the reference to the static field PrintStream is fetched (code 8), the value is displayed on the standard output (code 27).

If you have followed what I said before, you may ask why is an instance of StringBuilder created? after all the code source has no reference to _StringBuilder_. The answer lies in the fact that all of the substrings building the final String are known at compile time. In this specific case, the Java compiler (written by people who know the drawback of the _+_ operator) optimizes the bytecode that is generated. In our case, String concatenation with the _+_ operator is replaced by:

```java
new StringBuilder().append("").append("some more data");
```

This optimization is known as a static string concatenation optimization and is available since Java 5.

So, does it means that all the previous explanations about the cost of the _+_ operator no longer hold? at this point it's true for _static_ string concatenation. However, investigations are still required with _dynamic_ string concatenation.

# Going further with dynamic string concatenation

Dynamic string concatenation refers to the concatenation of substrings whose the result is known at runtime only. This is for instance the case for substrings appended to a String in a for loop:

```java
public class DynamicStringConcatenation {
    public static void main(String[] args) {
        String result = "";
        for (int i = 0; i < 1e6; i++) {
            result += "some more data";
        }
        System.out.println(result);
    }
}
```

Below is the disassembled human readable bytecode:

```java
$ javap -c ./build/classes/main/DynamicStringConcatenation.class
Compiled from "DynamicStringConcatenation.java"
public class DynamicStringConcatenation {
  public DynamicStringConcatenation();
    Code:
       0: aload_0          // Push 'this' on to the stack
       1: invokespecial #1 // Invoke Object class constructor
                           // pop 'this' ref from the stack
       4: return           // Return from constructor

  public static void main(java.lang.String[]);
    Code:
       0: ldc            #2 // Load constant #2 on to the stack
       2: astore_1          // Create local var from stack, pop #2
       3: iconst_0          // Push value 0 onto the stack
       4: istore_2          // Pop value and store it in local var
       5: iload_2           // Push local var 2 on to the stack
       6: i2d               // Convert int to double on
                            // top of stack (pop + push)
       7: ldc2_w         #3 // Push constant 10e6 on to the stack
      10: dcmpg             // Compare two doubles on top of stack
                            // pop twice, push result: -1, 0 or 1
      11: ifge           40 // if value on top of stack is greater
                            // than or equal to 0 (pop once)
                            // branch to instruction at code 40
      14: new            #5 // Push new StringBuilder ref on stack
      17: dup               // Duplicate value on top of the stack
      18: invokespecial  #6 // Invoke StringBuilder constructor
                            // pop object reference
      21: aload_1           // Push local var 1 (empty String)
                            // on to the stack
      22: invokevirtual  #7 // Invoke StringBuilder.append
                            // pop obj ref + param, push result
      25: ldc            #8 // Push "some more data" on the stack
      27: invokevirtual  #7 // Invoke StringBuilder.append
                            // pop obj ref + param, push result
      30: invokevirtual  #9 // Invoke StringBuilder.toString
                            // pop object reference
      33: astore_1          // Create local var from stack (pop)
      34: iinc         2, 1 // Increment local variable 2 by 1
      37: goto            5 // Move to instruction at code 5
      40: getstatic     #10 // Push value System.out:PrintStream
      43: aload_1           // Push local var 1 (result String)
      44: invokevirtual #11 // Invoke method PrintStream.println()
                            // pop twice (object ref + parameter)
      47: return            // Return void from method
}
```

If you look quickly at the instructions and comments, you can see there are some references to _StringBuilder_. However, it does not mean that, in this context, String concatenation is "optimized". A closer look (by drawing for instance how the _stack_ evolves) will show you that a new _StringBuilder_ instance is created per iteration. That's because optimization for static string concatenation is applied in the body of the loop but not outside. The compiler cannot compute the concatenating result without executing the instructions, which is not its role.

Supposing that the source code associated to the bytecode of the class _DynamicStringConcatenation_ has to be displayed, then this one would look as follows:  

```java
String result = "";
for (int i = 0; i < 1e6; i++) {
    StringBuilder tmp = new StringBuilder();
    tmp.append(result);
    tmp.append("some more data");
    result = tmp.toString();
}
System.out.println(result);
```

Based on the code, it means that explanations given in [Understanding the issue](#understanding-the-issue) section about the performance issue still hold for dynamic String concatenation. Using the _+_ operator for concatenating substrings to a String defined outside the body of the loop will cause severe performance degradations.
Although _StringBuilder_ is used by the compiler, an instance must be created at each iteration and the characters inside the _result_ variable copied to the _StringBuilder_ instance before appending "some more data" and returning a String representation with _toString_. This last incurring another copy of characters contained by the _StringBuilder_ instance.

One solution is to manually create a _StringBuilder_ instance outside the loop:

```java
StringBuilder result = new StringBuilder((int)14e6);
for (int i = 0; i < 1e6; i++) {
    result.append("some more data");
}
System.out.println(result.toString());
```

Besides, if you know in advance the total number of characters that will be appended to the _StringBuilder_ instance, you can pass this value to the constructor. It will prevent some resize operations and thus give better results.

# Assessing performance with micro-benchmarks

Until now it has been clarified that dynamic string concatenation with the _+_ operator is not optimized in Java 8 by the compiler, similarly to previous Java versions. However, nothing can be concluded yet. Indeed, the JVM is highly optimized and optimizations which are not made at compile time can be performed at runtime by the [Just-In-Time (JIT)](https://en.wikipedia.org/wiki/Just-in-time_compilation) compiler.

The purpose of the JIT is twofold. First it is used to analyze method calls in background and to compile the bytecode of methods that are frequently used into native CPU instructions. Thus, once a method has been compiled, its native form is used, which avoids an indirection with the interpretation of the bytecode. Second, the JIT can analyze dynamic runtime information to make optimizations that a compiler cannot. For example, inlining functions that are used frequently, eliminating dead code, removing locks if monitor is not reachable from other threads, etc. This way, a code written in Java may sometimes run faster than its equivalent in C.

Since the Java HotSpot Performance Engine (JVM) apply many optos, maybe some magic tricks with dynamic string concatenation occurs at runtime. To check this assumption, the best is to [look at the implementation](http://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/dae2d83e0ec2/src/share/vm/opto/stringopts.cpp) but it would require too much time without the guarantee not to forget to look at a piece of code. Another solution is to write micro-benchmarks to compare the time required to concatenate Strings in a for loop using the _+_ operator vs an instance of _StringBuilder_ .

Writing micro-benchmarks, especially in Java is not easy. As explained before, the JIT is performing many optimizations in a transparent manner. It implies to be aware of its optimizations, the effects of initialization, recompilation, etc. to write a meaningful micro-benchmark. Otherwise, you might measure something completely wrong. Hopefully, some libraries exist to help in this task. Especially, [Java Microbenchmark Harness (JMH)](http://openjdk.java.net/projects/code-tools/jmh/) which has the advantage to be written by ~~Russians~~ people working on the JIT implementation.

Below are the micro-benchmarks written to assess String concatenation performance using JMH:

```java
@State(Scope.Thread)
@BenchmarkMode(Mode.SingleShotTime)
@Measurement(batchSize = 100000, iterations = 20)
@Warmup(batchSize = 100000, iterations = 10)
@Fork(5)
public class StringConcatenationBenchmark {
    private String string;
    private String stringConcat;
    private StringBuilder stringBuilder;
    private StringBuffer stringBuffer;

    @Setup(Level.Iteration)
    public void setup() {
        string = "";
        stringConcat = "";
        stringBuilder = new StringBuilder();
        stringBuffer = new StringBuffer();
    }

    @Benchmark
    public void stringConcatenation() {
        string += "some more data";
    }

    @Benchmark
    public void stringConcatConcatenation() {
        stringConcat = stringConcat.concat("some more data");
    }

    @Benchmark
    public void stringBuilderConcatenation() {
        stringBuilder.append("some more data");
    }

    @Benchmark
    public void stringBufferConcatenation() {
        stringBuffer.append("some more data");
    }
}
```
The previous class is [available on Github](https://github.com/lpellegr/experiments/blob/master/java/string-concatenation/src/jmh/java/link/pellegrino/string_concatenation/StringConcatenationBenchmark.java) packaged in a gradle project. If you want to run micro-benchmarks on your side, you can as follows once the project is cloned:

```bash
$ ./gradlew jmh
```

Briefly speaking, iterations are made by JMH using the _batchSize_ parameter with _Measurement_ and _Warmup_ annotations. This last annotation is useful to perform runs that aim to warm the JVM so that JIT optimizations are in place when measurements are made. More information about JMH and its annotations can be found on [java-performance.info](http://java-performance.info/jmh/).

The next figure sketches the trends:

![tre](https://docs.google.com/spreadsheets/d/1dV4Pbe2_ZCsc9TDBYsN9u69a2a3xSjCAzxKR7I6fxzg/pubchart?oid=1847999196&format=image)

Using _StringBuilder_/_StringBuffer_ clearly outperform other approaches which use the _+_ operator or _String#concat(String)_ for dynamic String concatenation. Although _String#concat(String)_ scales in a similar manner as the method based on the _+_ operator, the difference of performance between both may be explained by the fact that no transformation is performed by the compiler for _String#concat(String)_. This last does not require to create multiple StringBuilder instances while avoiding the extra copy incurred by the call to _StringBuilder#toString()_.

# Conclusion

In conclusion, Java 8 seems not to introduce new optimizations for String concatenation with the _+_ operator. It means that using _StringBuilder_ manually is still required for specific cases where the compiler or the JIT is not applying magic tricks. For instance, when lot of substrings are concatenated to a String variable defined outside the scope of a loop.

The reason for not optimizing automatically all String concatenations is still a bit obscure to me. Probably, too much information and efforts are required to handle  all possible cases safely. After all, that's also a good point to make programmers think about what they write.

If you are interested by String optimizations in Java and their associated methods, I recommend to have a look at the interesting [slides made by Aleksey Shipilёv](http://shipilev.net/talks/joker-Oct2014-string-catechism.pdf).
