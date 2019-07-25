---
layout: post
title:  "Dump your JVM"
date:   2019-07-20 00:00:00 +0200
tags:
- jvm
- java
- scala
- oom
- jmc
- mat
- eclipse
- jdk
- heap
comments: true
---

This is a ultra-short post on JVM debugging tools. Did you get an `OutOfMemoryError` and have no idea how to proceed? This post is for you.
  
## A dummy example application

I'd like to start with a dummy application as example. We will make it run and analyse it.

This application simply will create a huge amount of `UUID` instances. If we analyse it correctly, we should see them somewhere in our memory heap.

Put in `Main.scala` the following:

<!--more-->

```
package com.mauritania

import java.util.UUID.randomUUID

object Main {

  case class Myuids(ui: String) // my unique id string dummy class

  def main(args: Array[String]): Unit = {

    val u = (1 to args(0).toInt).map(_ => Myuids(randomUUID().toString))

    java.lang.Thread.sleep(3600 * 1000)

    u.foreach(println)

  }

}
```

Clearly we're allocating many `Myuids` instances.
Launch it as follows (using `scalac` 2.11.7 here):

```
scalac Main.scala
scala com.mauritania.Main 1500000

```

Let's now analyse it.

## Generating heap dumps

There are two ways of generating heap dumps (`.hprof` files):

 1. Using `jmap` JDK's tool as follows:

 ```
 jmap -dump:format=b,file=heap.hprof <pid-of-running-jvm>
 ```
 2. Connecting to JVM via `mat` tool
 3. Connecting to JVM via `jmc` tool
 4. Connecting to JVM via `jvisualvm` tool
 5. Requesting the JVM to dump the heap on OOM using the following JVM settings:

 ```
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/tmp/heap.dump/
```

## Analysing heap dumps

### Eclipse Memory Analyser (with `mat`)

The easiest way is using `mat` tool.

1. Download the standalone Eclipse Memory Analyser (EMA, or `mat`).
2. Open `mat`

![Mat](/images/posts/dump-jvm/mat-init.png)

3. Get the memory dump of the just started JVM, it must be an `hprof` file.
4. Choose the `Component report`

![Component](/images/posts/dump-jvm/mat-choose-component.png)

5. Point to the package you're monitoring (in a regex), for instance `com\.mauritania\..*`
6. Now you must see a pie chart.

![Pie](/images/posts/dump-jvm/mat-pie-chart.png)

7. Click on `Top Consumers`, see their size in MB.

![Top](/images/posts/dump-jvm/mat-top-consumers.png)

The chart shows how `Myuids` instances are occupying the heap.

Note: normally you can also open `.hprof` files with `jhat`.

### JVM Memory analysis (with `jmc`)

1. Add the following settings to your JVM:

```
-XX:+StartAttachListener
-XX:+UnlockCommercialFeatures
-XX:+FlightRecorder
-XX:FlightRecorderOptions=
  defaultrecording=true,
  dumponexit=true,
  dumponexitpath=/tmp/jfr/,
  repository=/tmp/jfr/,
  disk=true
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/tmp/heap.dump/
```

For our example I had to launch our application as follows: 

```
java -cp .:<path-to>/scala/lib/scala-library.jar \
  -XX:+UnlockCommercialFeatures \
  -XX:+FlightRecorder \
  com.mauritania.Main 1500000
```
2. Upon an `OutOfMemoryError` the `HeapDump*` settings will make the JVM create a heap dump under `/tmp/heap.dump/java_pidXXXXX.hprof`
3. Upon exit the `FlightRecorder*` settings will make the JVM create a report under `/tmp/jfr/hotspot-pid-XXXXX-id-XXXXXXXXXXX.jfr` (which does not have memory heap exhaustive information, but more general indicators)
4. You can open the `.hprof` heap dump as seen in the sections above.
5. To open the `.jfr` you need to use `Java Mission Control` (tool from jdk: `jmc`)
6. Also instead of opening an existent `.jfr` you can make `jmc` connect to an existent JVM, as follows:

a. Create a new connection
![Connect](/images/posts/dump-jvm/jmc-connect.png)
b. Set up the recording settings 
![Save](/images/posts/dump-jvm/jmc-save.png)
![Save](/images/posts/dump-jvm/jmc-settings.png)
c. Interestingly you can request `jmc` to record certain events from the JVM, like `file open` event. This can be useful if you consider your application is slow because it has too much IO. 
![Event](/images/posts/dump-jvm/jmc-event-recording-settings.png)
d. Start recording
![Start](/images/posts/dump-jvm/jmc-start.png)
![Rec](/images/posts/dump-jvm/jmc-recording.png)
e. See general performance indicators, their evolution in time too
![Stats](/images/posts/dump-jvm/jmc-stats1.png)
f. Go deeper into memory consumption under package `org.mauritania`

![Stats](/images/posts/dump-jvm/jmc-object-statistics.png)


## Extra notes

Use the following JVM settings to get garbage collection activities logs. 

```
-XX:+PrintGCDetails 
-XX:+PrintGCTimeStamps
```

