---
layout: post
title:  "Dump your JVM"
date:   2019-07-20 00:00:00 +0200
tags:
- jvm
- java
- heap
comments: true
---
# JAVA

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

## JVM Memory analysis (JVM running locally)

Let's say you can launch the JVM locally.

### Eclipse Memory Analyser (`mat`)
You can use `mat` tool to go deeply into memory details.

1. Download the standalone Eclipse Memory Analyser (EMA, or `mat` as they call it).
2. Open `mat`

![Mat](/images/posts/dump-jvm/mat-init.png)

3. Get the memory dump of the just started JVM. There are two ways:
 - You can get it with `jmap -dump:format=b,file=heap.hprof <pid>`
 - Or you can acquire it from `mat` itself.
4. Choose the `component report`

![Component](/images/posts/dump-jvm/mat-choose-component.png)

5. Point to the right package you're monitoring (in a regex), for instance `com\.mauritania\..*`
6. Now you must see a pie chart.

![Pie](/images/posts/dump-jvm/mat-pie-chart.png)

7. Click on `Top Consumers`, see their size in MB.

![Top](/images/posts/dump-jvm/mat-top-consumers.png)

Note: you can also open `.hprof` files with `jhat`.

You can also

## JVM Memory analysis (JVM running remotely)

Let's say you can't launch the JVM locally (it's running in a cluster because it has data dependencies for example). Then proceed as follows:

1. Add the following settings to your JVM:

```
-XX:+PrintGCDetails 
-XX:+PrintGCTimeStamps
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
-XX:HeapDumpPath=/tmp/heap.dump/"
```
2. Upon an `OutOfMemoryError` the above commands will make the JVM create:
 - A report under `/tmp/jfr/hotspot-pid-XXXXX-id-XXXXXXXXXXX.jfr` (which does not have memory heap exhaustive information, but more general indicators)
 - A heap dump under `/tmp/heap.dump/java_pidXXXXX.hprof`
3. To open the `.jfr` you need to use `Java Mission Control` (tool from jdk: `jmc`)
4. To open the `.hprof` heap dump you need to use `jhat` or `jvisualvm`.

I will add example images in updates of this post.

