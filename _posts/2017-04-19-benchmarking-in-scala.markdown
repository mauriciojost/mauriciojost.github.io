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
- jmh
comments: true
---
## Why benchmarking?


Coding consciously and the use of code reviews are of great importance when it comes to writing clean and efficient code.
But sometimes I feel like I need stronger proofs to go one way or another, specially when I don't really know what is 
happening under the JVM hood.

A number describing the current status of your implementation will let you firstly gain awareness, 
secondly decide if improvement is worth the investment, 
and finally measure the improvement of your change. But it is not so easy...

<!--more-->

## What is the problem with it? 

When it comes to performance of an algorithm, we can get such metric by doing **benchmarking**. 

> _What can be so complicated about it? Just launch the algorithm many times and measure its execution time, and voila!!!_

Nope, benchmarking is not so trivial, specially on top of JVM. Scala by itself applies more than 
[15 phases](https://wiki.scala-lang.org/display/SIW/Overview+of+Compiler+Phases) when 
compiling trying to optimize the algorithm, and the JVM can also apply very clever optimizations at run time, leading to a (very) fooled conclusion.

For instance, try to explain why the comparative benchmark set
[org.mauritania.minibenchmark.catalog.IdentityTricky](https://mauriciojost.github.io/scala-benchmark/) 
below (the suspiciously even one) yields such unexpected results for 
[these very different algorithms](https://github.com/mauriciojost/scala-benchmark/blob/master/src/main/scala/org/mauritania/minibenchmark/catalog/IdentityTricky.scala). 
Found the reason?

[![Project](https://browshot.com/screenshot/image/56100717?&width=5500&height=3500)](https://mauriciojost.github.io/scala-benchmark/)

## And the solution?

The one I recommend is to use [JMH](http://openjdk.java.net/projects/code-tools/jmh/), the harness for Java benchmarking that is 
exploitable from Scala thanks to [sbt-jmh](https://github.com/ktoso/sbt-jmh).

## How to get started right now?

**I've set up a [project github/scala-benchmark](https://github.com/mauriciojost/scala-benchmark) which 
renders [visual reports](https://mauriciojost.github.io/scala-benchmark/) that GitHub can display via GitHub pages.**

Also if you want to know more, I really recommend [this read about JMH](http://tutorials.jenkov.com/java-performance/jmh.html).

**Won't you benchmark anything?**


