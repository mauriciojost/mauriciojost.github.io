---
layout: [post, presentation]
title:  "Exception Handling in Spark 2.x"
date:   2017-11-08 00:00:00 +0200
reveal:
  theme: ../../../css/theme/whiteish
  center: true
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

# Why Exception Handling (EH) in Spark?

- **data is rarely ideal**
- not all scenarios are not worth an **immediate** halt
- investigate newer scenarios as-per-priority (happier customers)
- ease product evolution
- understand application limitations

<!--slide-next-->

<!--more-->

# What are Exceptions?

Exceptions are **failures** that **prevent our code from completing successfully an operation**.

<!--slide-next-->

# Types of Failures

Failures [can be classified as](https://tersesystems.com/blog/2012/12/27/error-handling-in-scala/):

- External (more related to external conditions)
  - Expected (a parsing exception)
  - Unexpected (a host down)
- Internal
  - Unexpected (a `NullPointerException`)
  - Expected (a circuit breaker)

<!--slide-down-->

In Scala, failures can be classified as:

- `Fatal` or `NonFatal`
- `Deterministic` or `Non deterministic`

<!--slide-next-->

## Spark Exception Handling (EH)

We can classify exceptions in Spark in two groups:

- Unexpected failures (mostly non-deterministic, fatal)
- Expected failures (mostly deterministic, not fatal)

<!--slide-next-->

### Framework EH

Unexpected failures are generally tackled by the framework via task retries.

These represent non deterministic failures like network problems, memory exceptions, among others.

<!--slide-next-->

### Application EH

Applications on top of Spark need to handle expected failures.

These are generally `NonFatal` and `Deterministic`.

<!--slide-down-->

We will focus on these from now on.

<!--slide-next-->

# Application EH approaches

EH specially applies to transformations done to unstructured data (`RDD`).

<!--slide-next-->

## The no-exception-handling approach

**The world has to be ideal, or bang.**

The Spark app will fail if upon retries a task of keeps failing.

<!--slide-next-->

## The try-catch and log approach

A transformation reports unexpected scenarios via logs, which can be analysed post-mortem.

- **The world does not have to be ideal**
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



