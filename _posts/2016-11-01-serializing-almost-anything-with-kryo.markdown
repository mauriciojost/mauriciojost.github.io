---
layout: post
title:  "Serializing (almost) Anything with Kryo (for Spark)"
date:   2016-11-01 00:00:00 +0200
tags:
- spark 
- kryo 
- serialization 
- register 
- class 
- private
comments: true
disqusid: serializingkryo
---
##  What is Kryo?

Kryo serialization is one of the fastest on-JVM serialization libraries, and it is certainly the most popular in the Spark world.

To get the most out of this algorithm you must register the few classes that will have to be serialized. This will help to decrease the size of serialized objects, as their serialization will be tailor-made optimized by Kryo.

Registering your classes with Kryo in Spark is done this way:

<!--more-->


```scala
val sparkConf = new SparkConf()
...
sparkConf.registerKryoClasses(
   Array(
       // your classes here
   )
)
```

##  How to serialize unaccessible classes?

It all goes fine until you hit private classes, or arrays of classes. If you tried to serialize classes from the Joda library probably you know what I am talking about. However there are a few tricks that will help you serialize almost anything:  

```scala
// scala basic classes

Class.forName("scala.collection.immutable.$colon$colon")

Class.forName("scala.collection.immutable.Nil$")

classOf[Array[Tuple2[_,_]]]

// arrays of primitive classes

classOf[Array[String]]

classOf[Array[Int]]

// monads of primitive classes

classOf[Option[String]]

classOf[Option[Boolean]]

// case objects

Class.forName("scala.None$")

// protected static final classes

ClassTag(Class.forName("org.roaringbitmap.RoaringArray$Element"))
   .wrap.runtimeClass

// public static class FakeFileStatus

Class.forName(
   "org.apache.spark.sql.sources.HadoopFsRelation$FakeFileStatus")

ClassTag(Class.forName(
   "org.apache.spark.sql.sources.HadoopFsRelation$FakeFileStatus"))
   .wrap.runtimeClass

// joda classes

classOf[org.joda.time.tz.DateTimeZoneBuilder]

classOf[org.joda.time.tz.FixedDateTimeZone]

Class.forName(
   "org.joda.time.tz.DateTimeZoneBuilder$PrecalculatedZone")

Class.forName("org.joda.time.tz.DateTimeZoneBuilder$DSTZone")

Class.forName("org.joda.time.tz.DateTimeZoneBuilder$Recurrence")

Class.forName("org.joda.time.tz.DateTimeZoneBuilder$OfYear")

Class.forName("org.joda.time.tz.CachedDateTimeZone$Info")

ClassTag(Class.forName(
   "org.joda.time.tz.CachedDateTimeZone$Info")).wrap.runtimeClass
```

