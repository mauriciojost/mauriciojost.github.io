---
layout: post
title: Just in Time or not
comments: true
tags:
- Java
- Just in Time (JIT)
- Dynamic Translation
---

Java is known to compile source code to Bytecode, thus enabling portability at
the price of having a Java Virtual Machine (JVM) installed on the node that
needs to execute your Bytecode. The main drawback of Bytecode is that it needs 
to be interpreted (i.e. translated to binary code understandable by a CPU), 
which incurs some performance penalties. 
Fortunately, like several modern runtime environments (such as the ones used for
the .NET or Racket language), Java makes use of dynamic translation to  
