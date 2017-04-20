---
layout: post
title:  "Measuring the Performance of Anything In Scala"
date:   2017-04-19 00:00:00 +0200
tags:
- scala 
- performance 
- benchmark 
- api 
- collections
comments: true
disqusid: benchmarkingscala
---
## Why benchmarking?

Because engineers love numbers. No, seriously, **we love them**. And we love them because of a simple reason: they are not based on opinions easily biased by anyone, but on concrete facts. 

A number describing the current status will let you firstly get aware, secondly decide if improvement is worth the investment, and finally if your change brings the expected improvement.

## What is the problem with it? 

When it comes to performance of an algorithm, we can get such metric by doing **benchmarking**. However benchmarking is not trivial, specially when it comes of algorithms that run on top of the JVM. Scala and the JVM can both apply very clever optimizations at compile and run time, leading to a fooled conclusion. 

## What is the solution?

Use [JMH](http://openjdk.java.net/projects/code-tools/jmh/).


Mind that by benchmarking, you coding conciously and code reviews have any less value, it's complementary to them. 

http://tutorials.jenkov.com/java-performance/jmh.html



