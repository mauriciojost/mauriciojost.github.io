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

## Why Memory Spaces? 

As you probably know, Java provides automatic memory handling. This means, happily for us developers, that the JVM is responsible of freing unused memory transparently. 

Memory handling in the JVM happens happens thanks to the Garbage Collector. Every round, the GC:

- marks used memory and;

- deletes unused memory (with or without compacting). 

As simple as it is, these steps turn out to become more inneficient as the amount of used memory grows. 

Fortunately, empirical analysis showed applications have mostly short-lived objects. This means that introducing many Memory Spaces (or _Generations_ of memory) actually helps making garbage collection a more efficient process. 

## Permanent and non-permanent objects

Objects can be classified into:

- Permanent objects: mostly class objects, non disposable, these are out of the scope of the GC.

- Non-permanent objects: the rest of objects, likely to be disposed, are in the scope of the GC.
 
## The Java Memory Spaces

The Java Memory Spaces depend on the Java VM implementation, but in general terms can be divided into: 
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

In JDK 8, the permanent generation was removed and the class metadata is allocated in native memory. The amount of native memory that can be used for class metadata is by default unlimited. Use the option MaxMetaspaceSize to put an upper limit on the amount of native memory used for class metadata.


## See it by yourself

```bash
spark-shell --driver-memory 1G
spark-shell --driver-memory 1G --packages log4j:log4j:1.2.17
spark-shell --driver-memory 2G --packages log4j:log4j:1.2.17

```
```bash
jconsole
man --manpath /home/mjost/opt/zips/jdk1.7.0_79/man java
htop
```

## Documentation
General documentation from Oracle about Java: http://docs.oracle.com/en/java/
man java
http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html
http://docs.oracle.com/javase/6/
http://docs.oracle.com/javase/7/
http://docs.oracle.com/javase/8/


