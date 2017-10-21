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


Coding consciously and the use of code reviews are of great importance when it comes to writing clean and efficient code. Sometimes however, I feel like I need stronger reasons to go one way or another, specially when I don't really know what is happening under the JVM hood.

A benchmark helps describing the current status of your implementation. It provides awareness, helps deciding if improvement is worth the investment, and finally helps measuring the improvement of your change (if any). 

Unfortunately getting such number is not so easy, but fortunately there are good tools to do it correctly. Keep reading if you're interested.

<!--more-->

## What is the problem with benchmarking? 

With benchmarking we can determine the performance of an algorithm. However getting meaningful data is tricky.

> _What can be so complicated about it? Just launch the algorithm many times and measure its execution time, and voila!!!_

Nope, benchmarking is not so trivial, specially on top of JVM. Scala by itself applies more than 
[15 phases](https://wiki.scala-lang.org/display/SIW/Overview+of+Compiler+Phases) when 
compiling trying to optimize the algorithm, and the JVM can also apply very clever optimizations at run time, leading to a fooled conclusion.

For instance, try to explain why the comparative benchmark set
[org.mauritania.minibenchmark.catalog.IdentityTricky](https://mauriciojost.github.io/scala-benchmark/) 
below (the suspiciously even one) yields such unexpected results for 
[these very different algorithms](https://github.com/mauriciojost/scala-benchmark/blob/master/src/main/scala/org/mauritania/minibenchmark/catalog/IdentityTricky.scala). 
Found the reason?

[![Project](/images/posts/scala-benchmark.png)](https://mauriciojost.github.io/scala-benchmark/)

## And the solution?

The one I recommend is to use [JMH](http://openjdk.java.net/projects/code-tools/jmh/), the harness for Java benchmarking that is exploitable from Scala thanks to [sbt-jmh](https://github.com/ktoso/sbt-jmh).

There is also [ScalaMeter](https://scalameter.github.io/) that should be taken into account, I haven't personally used it yet at the moment of writing this post. 

## How to get started right now?

**I've set up a [project github/scala-benchmark](https://github.com/mauriciojost/scala-benchmark) which 
renders [visual reports](https://mauriciojost.github.io/scala-benchmark/) that GitHub can display via GitHub pages.** 
Help yourself and fork it if you like the idea.

## References

Also if you want to know more, I really recommend [this read about JMH](http://tutorials.jenkov.com/java-performance/jmh.html).

# Enjoy!


