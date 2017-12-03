---
layout: [post, presentation]
title:  "Exception Handling in Spark 2.x"
date:   2017-11-08 00:00:00 +0200
tags:
- scala
- spark
- error
- exception
- handling
- try
- catch
comments: true
---

# What are Exceptions?

Exceptions are failures that prevent our code from completing successfully an operation.

<!--slide-next-->

# Types of Failures

Failures [can be classified as](https://tersesystems.com/blog/2012/12/27/error-handling-in-scala/):

- Internal: 
  - Unexpected failure: a `NullPointerException`
  - Expected failure: a circuit breaker
- External: 
  - Expected failure: a parsing exception
  - Unexpected failure: a host down

<!--slide-down-->

In Scala, failures can be classified as:

- `Fatal` or `NonFatal`
- `Deterministic` or `Non deterministic`

<!--slide-next-->

## Spark Exception Handling

Unexpected failures are generally tackled by Spark via task retries.

These represent network problems, memory exceptions, among others.

<!--slide-next-->

## Application Exception Handling

Applications on top of Spark need to handle expected failures.

These are generally `NonFatal` and `Deterministic`.

We will focus on these from now on.

<!--slide-next-->

# Application Exception Handling approaches

Exception handling specially applies to transformations done to
unstructured data (`RDD`). Exception handling for transformations done over
more structured data (like a `DataFrame`) is out of the scope of the post.

<!--slide-next-->

## The no-exception-handling approach

The Spak app will fail if upon retries a given task of a transformation keeps failing
(because of parsing, unexpected data scenarios, among others).

**Ideal world, or death.**

<!--slide-next-->

## The try-catch and log approach

A transformation reports unexpected scenarios via logs, which can be analysed post-mortem.

- **World is not ideal**
- May generate significant amount of logs
- May decrease the application performance significantly
- Discard unexpected scenario? Recovery?
- Mostly implemented in a not purely functional way

<!--slide-next-->

## The `Try` / `Either` approach

A transformation returns `Try` / `Either` types whenever unexpected scenarios are found.

- Purely functional
- `Exception` reports are part of the output of a transformation
- Discard unexpected scenario? Recovery?

<!--slide-next-->

## The Accumulator approach

Use the `Spark` `Accumulator` mechanism to report statistics on unexpected scenarios.

A labeled counter is increased and aggregated upon action completion.

- Purely functional
- Not meant to retrieve detailed information about the failure
- Discard unexpected scenario? Recovery?



<!--slide-next-->

## More evolved approaches



