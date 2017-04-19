---
layout: post
title: "Java Process API updates: kill them all!"
comments: true
tags:
- JDK 9
- JEP 102
- Process API
---

I am regularly looking at the [JDK Enhancement Proposals](http://openjdk.java.net/jeps) (JEPs) targeted for the next major Java release. One that has caught my attention is about the Process API. If you have already played with processes from a Java JVM you probably know how complex and not reliable killing a process is, especially on Windows.

Up to Java 8, the only viable implementation I was aware of for killing a process tree [comes from the Jenkins project](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/util/ProcessTree.java). Jenkins makes use of this feature to clean up the mess left by a build. For the needs of some projects in the company I am working at, the implementation has been [extracted to a dedicated _project_](https://github.com/ow2-proactive/process-tree-killer). This last relies on JNA and [Winp](https://github.com/kohsuke/winp). Unfortunately, its maintenance has a cost: it was noted on numerous occasions that [processes are not killed as they should on some Windows environments](https://github.com/kohsuke/winp/pull/20).

<!--more-->

# [Duke](http://www.oracle.com/us/technologies/java/duke-424174.html) version 9 to the rescue

General availability for JDK 9 is [planned for mid 2017](http://openjdk.java.net/projects/jdk9/), this new release will include enhancements related to JEP 102, namely a better Process API.
