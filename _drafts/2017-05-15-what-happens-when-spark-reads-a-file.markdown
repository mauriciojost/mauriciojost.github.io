---
layout: post
title:  "What Happens when Spark reads a file"
date:   2017-05-15 00:00:00 +0200
tags:
- scala 
- spark
- hadoop
- hdfs
- inputformat
- mapreduce
comments: true
---
## Really, what happens?
 
When Spark reads a simple file from HDFS there is a lot going on in your cluster.
A single file is normally stored in many nodes, which is the result of both, replication and splitting mechanisms.
They are both are essential for fault tolerance and performance.





![Alt text](https://g.gravizo.com/svg?
  digraph G {
    aize ="4,4";
    main [shape=box];
    main -> parse [weight=8];
    parse -> execute;
    main -> init [style=dotted];
    main -> cleanup;
    execute -> { make_string; printf}
    init -> make_string;
    edge [color=red];
    main -> printf [style=bold,label="100 times"];
    make_string [label="make a string"];
    node [shape=box,style=filled,color=".7 .3 1.0"];
    execute -> compare;
  }
)

<!--more-->

## Another title



