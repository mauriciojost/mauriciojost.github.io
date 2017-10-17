---
layout: [post, presentation]
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

This post addresses:

- what are Java Memory Spaces
- why they are such a good idea
- their names and use in the JVM
- how to measure their usage in practice
- where to find more documentation about them

<!--slide-down-->

So, if you don't understand concepts like:

- `OutOfMemoryError`
- `PermGen`
- `heap memory`
- etc.

Then I suggest you to continue reading!

<!--slide-next-->

<!--more-->

## Why the need for Memory Spaces?

<!--slide-ignore-begin-->

The JVM frees unreferenced memory via an entity called Garbage Collector (or GC for short).
Every time the GC claims memory, it executes these steps:

<!--slide-ignore-end-->

![Alt text](https://g.gravizo.com/svg?
@startuml;
skinparam monochrome false;
caption Figure 1. The steps of the Garbage Collection (GC);
scale max 900 width;
;
(*) -right-> "1. Mark used memory" %23white;
-right-> "2. Delete unused memory" %23white;
-right-> "3. Compact used memory" %23white;
-right-> \(*\);
@enduml;
)

<!--slide-ignore-begin-->

If these steps were to be applied to a flat memory space, the process of freeing memory would become
proportionally as slow as the amount of memory used. In other words, the more classes loaded, the more
memory segments to explore every time memory is claimed.

As you could imagine, things get better if the GC is aware of the odds an object is eligible for disposal.

In a simplified version of reality, the GC considers a class object to be permanent (as it will probably
live as long as the JVM).

On the other hand, the GC considers objects created with the _new_ keyword as
more likely to have shorter life. The GC discriminates _very short life_ from _medium life_ and _long life_
by keeping count of the amount of times an object survived a GC cycle. Objects survive a GC cycle when they
are still referenced (hence their block of memory is marked, preventing it from disposal).

Objects that survived some GC cycles are less eligible for disposal soon, and we can say they change
their _generation_.

This categorisation of objects into generations really exists, and is materialised in JVMs via Memory Spaces,
or more precisely _Generational Memory Spaces_.

<!--slide-ignore-end-->

<!--slide-next-->

## What are the Memory Spaces in Java?

<!--slide-ignore-begin-->

Strictly speaking, the Java Memory Spaces really depend on the Java VM implementation, but in general
terms they can be divided into:

<!--slide-ignore-end-->

![Alt text](https://g.gravizo.com/svg?
@startuml;
skinparam monochrome false;
caption Figure 2. Java Memory Spaces (MP stands for Memory Pool);
scale max 900 width;
rectangle "JVM Memory" {;
  rectangle "Heap" {;
    rectangle "Young\\nGeneration" {;
      rectangle eden as "MP PS\\nEden\\nSpace" %23red;
      rectangle survivor as "MP PS\\nSurvivor\\nSpace" %23orange;
    };
    rectangle "Old\\nGeneration" {;
      rectangle oldgen as "MP PS\\nOld Gen" %23blue;
    };
  };
  rectangle OffHeap {;
    rectangle metaspace as "MP\\nMetaspace";
    rectangle codecache as "MP\\nCodecache";
    rectangle classspace as "MP\\nCompressed\\nClass Space";
  };
};
note right of OffHeap %23white;
  Not subject to GC.;
end note;
;
note right of Heap %23white;
  All object instances;
  are stored here,;
  memory from this;
  space is used whenever;
  new is present in the;
  code.;
  Subject to GC.;
end note;
;
note right of metaspace %23white;
  It used to be;
  PermGen before;
  Java 8.;
end note;
;
note right of codecache %23white;
  Contains compiled;
  native code, mostly;
  used by the JIT.;
end note;
;
note right of eden %23white;
   Recently allocated;
   objects, did not;
   survive any GC yet.;
end note;
;
note right of survivor %23white;
   Objects that have;
   survived at least;
   one GC.;
end note;
;
note right of oldgen %23white;
  Also called Tenured,;
  objects that have;
  survived some time;
  in the Survivor Space.;
end note;
;
@enduml;
)

<!--slide-down-->

### No PermGen Space in JDK 8?

Exactly, no more `PermGen`. 

In JDK 8 the permanent generation was removed. The class metadata is allocated in native memory instead.

<!--slide-ignore-begin-->

The amount of native memory that can be used for class metadata is by default unlimited. You can use the option `MaxMetaspaceSize` to put an upper limit on it.

<!--slide-ignore-end-->

<!--slide-next-->

## In practice, can I measure the use of Memory Spaces?

You can use `jconsole` for that. This tool will show you:

- the use of Memory Spaces
- the threads in your JVM (with name, status, stacktrace, etc.)
- loaded classes
- exposed MBeans
- and more!

<!--slide-down-->

### Example

We will use the Scala REPL as an example: 

```bash
scala
```

We will open `jconsole` and hook to the just launched JVM (using its PID).

```bash
jconsole <PID>
```

to hook to the corresponding JVM.

<!--slide-ignore-begin-->

What I see initially is:

<!--slide-ignore-end-->

<!--slide-down-->

{% img /images/posts/jconsole1.png 800x600 %}

<!--slide-down-->

However, if you perform a GC and then you create lots of objects with:

```
val a = (1 to 1000000).toList.map(_.toString)
```

<!--slide-down-->

<!--slide-ignore-begin-->

You will see:

<!--slide-ignore-end-->

{% img /images/posts/jconsole2.png 800x600 %}

<!--slide-down-->

Can you explain:

- what happens to the _Heap Memory Usage_ when we launched the GC? It drops, used memory was marked, letting GC dispose unused blocks of memory, freing it for new objects to use it.
- what happens when we created objects in Scala? See how the heap usage increases by about 100MiB. There is one new big object `val a` allocated.

<!--slide-down-->

And more generally:

- what happens to the Loaded classes? They increased by the team `val a` was instantiated given the lazy class loading.
- what happens to the use of CPU? There is a peak when `val a` was instantiated. Can you see it?

<!--slide-next-->

## More Documentation on it?

There is really lots of documentation about this topic. Whenever you read documentation about it, I suggest you to
double check the version of the JVM it relates too.

- [General documentation from Oracle about Java](http://docs.oracle.com/en/java/)
- [Java Garbage Collection Basics] (http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html)
- [JAVA SE 7](http://docs.oracle.com/javase/7/)
- [JAVA SE 8](http://docs.oracle.com/javase/8/)
- [JAVA SE 9](http://docs.oracle.com/javase/9/)

<!--slide-down-->

Also, do not forget `man java`. If java was not installed properly via a package manager, you can still try to read the manual with `man`. For example: 

```bash
man --manpath /home/mjost/opt/zips/jdk1.7.0_79/man java
```

<!--slide-next-->

Enjoy!
