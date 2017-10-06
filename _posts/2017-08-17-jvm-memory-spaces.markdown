---
layout: post
title:  "JVM Memory Spaces"
date:   2017-08-17 00:00:00 +0200
tags:
- scala
- java
- heap
- memory
- permgen
comments: true
---

## Why would we need Memory Spaces? 

The JVM is responsible of freing unreferenced memory via an entity called Garbage Collector (or GC for short). Every time the GC is requested to claim memory, it will execute two steps:

- mark used memory and

- delete unused memory (compacting could be part of this step too) 

It turns out that if we were to apply these two simple steps to a flat memory space, the process of freing memory would become as slow as the amount of memory used. For instance, the more classes loaded, the more memory segments to explore every time memory is claimed.

<!--more-->

As you could imagine, things get better if the GC is aware of the chances an object is eligible for disposal. For instance, the GC could consider a class oject to be permanent (as it will probably live as long as the JVM), whereas consider an object created with the _new_ keyword as more likely to have a very short life (unless it can learn the opposite, for instance when the object keeps being referenced for a really long time, decreasing the chances it will be eligible for disposal soon). 

Indeed, this categorisation exists and is implemented in modern JVMs, and is materialised via Memory Spaces, or more precisely _Generational Memory Spaces_. 

## What are the Memory Spaces in Java?

Strictly speaking, the Java Memory Spaces really depend on the Java VM implementation, but in general terms they can be divided into: 

- Heap Memory Usage (all object instances are stored here, memory from this space is used whenever _new_ is present in the code)

  - (Young Generation)

    - **Memory Pool PS Eden Space** (recently allocated objects, did not survive any GC yet)
    
    - **Memory Pool PS Survivor Space** (objects that have survived at least one GC)

  - (Old Generation)

    - **Memory Pool PS Old Gen** (also called **Tenured**, objects that have survived some time in the **Survivor Space**)

- **Non-Heap Memory Usage**

  - **Memory Pool Metaspace** (it used to be **PermGen** before Java 8)

  - **Memory Pool Codecache** (contains compiled native code, mostly used by the JIT)

  - **Memory Pool Compressed Class Space**

### No PermGen Space in JDK 8? 

Yes. 

In JDK 8 the permanent generation was removed, and the class metadata is allocated in native memory. The amount of native memory that can be used for class metadata is by default unlimited. You can use the option `MaxMetaspaceSize` to put an upper limit on it.

## Can I measure the use of Memory Spaces

Yes! 

You can use `jconsole`. It will show you not only the use of all the above mentioned Memory Spaces, but also the threads in your JVM with basic information about them (name, status, stacktrace, etc.), loaded classes, and access to expoed MBeans. 

### Example

We will use the Scala REPL as an example: 

```bash
scala
```

We will open `jconsole` and hook to the corresponding JVM. What I see initially is: 

![Project](/images/posts/jconsole1.png)

However, if I perform a GC and then I create lots of objects with: 

```scala
val a = (1 to 1000000).toList.map(_.toString)
```

I will see:

![Project](/images/posts/jconsole2.png)

Can you see what happens to the Heap Memory when I launched the GC? What happens when I created objects in Scala? And to the Loaded classes? Use of CPU?

Conclusions?

## Documentation

There is really lots of documentation about these topics, just make sure you don't drawn into the wrong documentation (see carefully the version and implementation of your JVM before passing any parameter). 

- [General documentation from Oracle about Java](http://docs.oracle.com/en/java/)
- [Java Garbage Collection Basics] (http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html)
- [JAVA SE 5](http://docs.oracle.com/javase/5/)
- [JAVA SE 6](http://docs.oracle.com/javase/6/)
- [JAVA SE 7](http://docs.oracle.com/javase/7/)
- [JAVA SE 8](http://docs.oracle.com/javase/8/)
- [JAVA SE 9](http://docs.oracle.com/javase/9/)

Also, do not forget `man java`. If java was not installed properly via a package manager, you can still try to read the manual with: 

```bash
man --manpath /home/mjost/opt/zips/jdk1.7.0_79/man java
```
