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

In this occasion I will explain what are the Java Memory Spaces. You should be interested if you're a developper often struggling to understand what an `OOM` or `OutOfMemoryError` is, what `PermGen` is, or 
what `heap memory` is.

I will also address why Memory Spaces are such a good idea, how their usage can be measured from a JVM, and where to find documentation about them.

## Why would we need Memory Spaces? 

The JVM is responsible of freing unreferenced memory via an entity called Garbage Collector (or GC for short). Every time the GC is requested to claim memory, it will execute these steps:

![Alt text](https://g.gravizo.com/svg?
@startuml;
skinparam monochrome false;
caption Figure 1. Garbage Collection (GC) steps;
scale max 900 width;
;
(*) -right-> "1. Mark used memory" %23white;
-right-> "2. Delete unused memory" %23white;
-right-> "3. Compact used memory" %23white;
-right-> \(*\);
@enduml;
)


<!--more-->

It turns out that if we were to apply these simple steps to a flat memory space, the process of freing memory would become as slow as the amount of memory used. In other words, the more classes loaded, the more memory segments to explore every time memory is claimed.

As you could imagine, things get better if the GC is aware of the odds an object is eligible for disposal. In a simplified version of reality, the GC considers a class oject to be permanent (as it will probably live as long as the JVM). On the other hand, the GC considers objects created with the _new_ keyword as more likely to have shorter life. The GC discriminates _very short life_ from _medium life_ and _long life_ by keeping count of the amount of times an object survived a GC cycle. Objects survive a GC cycle when they are still referenced (hence their block of memory is marked, preventing it from disposal). Objects that survived some GC cycles are less eligible for disposal soon, and we can say they change their _generation_. 

This categorisation of objects into generations really exists, and is materialised in JVMs via Memory Spaces, or more precisely _Generational Memory Spaces_. 

## What are the Memory Spaces in Java?

Strictly speaking, the Java Memory Spaces really depend on the Java VM implementation, but in general terms they can be divided into: 

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

### No PermGen Space in JDK 8? 

Exactly, no more `PermGen`. 

In JDK 8 the permanent generation was removed, and the class metadata is allocated in native memory instead. The amount of native memory that can be used for class metadata is by default unlimited. You can use the option `MaxMetaspaceSize` to put an upper limit on it.

## Can I measure the use of Memory Spaces?

Yes! 

You can use `jconsole`. It will show you not only the use of all the above mentioned Memory Spaces, but also the threads in your JVM with basic information about them (name, status, stacktrace, etc.), loaded classes, and access to expoed MBeans. 

### Example

We will use the Scala REPL as an example: 

```bash
scala
```

We will open `jconsole` and hook to the corresponding JVM. What I see initially is: 

{% img /images/posts/jconsole1.png 800x600 %}

However, if I perform a GC and then I create lots of objects with: 

```scala
val a = (1 to 1000000).toList.map(_.toString)
```

I will see:

{% img /images/posts/jconsole2.png 800x600 %}

Can you see what happens to the _Heap Memory Usage_ when I launched the GC? It drops, used memory was marked, letting GC dispose unused blocks of memory, freing it for new objects to use it.

What happens when I created objects in Scala? See how the heap usage increases by about 100MiB. There is one new big object `val a` allocated.

And to the Loaded classes? They increased by the team `val a` was instanciated given the lazy class loading. 

Use of CPU? Peak when `val a` was instanciated. Can you see it?

## More Documentation on it?

There is really lots of documentation about these topics, just make sure you don't drawn into the wrong documentation (see carefully the version and implementation of your JVM before passing any parameter). 

- [General documentation from Oracle about Java](http://docs.oracle.com/en/java/)
- [Java Garbage Collection Basics] (http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html)
- [JAVA SE 7](http://docs.oracle.com/javase/7/)
- [JAVA SE 8](http://docs.oracle.com/javase/8/)
- [JAVA SE 9](http://docs.oracle.com/javase/9/)

Also, do not forget `man java`. If java was not installed properly via a package manager, you can still try to read the manual with `man`. For example: 

```bash
man --manpath /home/mjost/opt/zips/jdk1.7.0_79/man java
```

Enjoy!
