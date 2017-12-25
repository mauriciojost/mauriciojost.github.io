---
layout: [post, presentation]
title:  "Exception Handling in Spark 2.x"
date:   2017-11-08 00:00:00 +0200
reveal:
  theme: ../../../css/theme/whiteish
  center: false
  history: true
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

# Why Exception Handling (E.H.) in Spark?

- **data is rarely ideal**
- some scenarios don't deserve an **immediate** halt
- investigate newer scenarios as-per-priority (happier customers)
- ease product evolution
- understand application limitations

<!--slide-next-->

<!--more-->

# What are Exceptions?

Exceptions are **failures** that **prevent our code from completing successfully an operation**.

<!--slide-ignore-begin-->

Generally speaking, in the batch & streaming processing world, correctly handling exceptions
gives the development team more time to evaluate logs and better decide how to handle different scenarios.

<!--slide-ignore-end-->

<!--slide-next-->

# Types of Failures

<!--slide-ignore-begin-->

Failures [can be classified as](https://tersesystems.com/blog/2012/12/27/error-handling-in-scala/):

- **Expected Internal** (a circuit breaker)
- **Expected External** (a parsing exception)
- **Unexpected Internal** (a `NullPointerException`)
- **Unexpected External** (a host down)

<!--slide-ignore-end-->

Among others, failures can be classified by importance:

- `NonFatal` (can be recovered)
- `Fatal` (cannot be recovered)

<!--slide-down-->

Or by determinism:

- `Deterministic` (can be reproduced consistently)
- `Non deterministic`

<!--slide-next-->

## Spark Exception Handling (E.H.)

Generally speaking, Spark exceptions can be divided in two groups:

- **Unexpected failures**: generally non-deterministic, fatal or non fatal (Spark framework via task retries)
- **Expected failures**: generally deterministic, non fatal -> **this post**

<!--slide-next-->

# Application E.H. approaches

- The no-exception-handling approach
- The try-catch and log approach
- The `Try` / `Either` approach
- The Accumulator approach
- More evolved approaches

<!--slide-next-->

## The no-exception-handling approach

**The world has to be ideal, or crash.**

The Spark app will fail if upon retries a task keeps failing.

<pre><code class="scala" data-trim contenteditable>
def country(cityCode: String): String = {
  cities(cityCode).get.country
  // the city has to be found!
}
</code></pre>

<!--slide-down-->

When to use? Prototypes only.

<!--slide-next-->

## The try-catch and log approach

Report unexpected scenarios via logs.

- May generate significant amount of logs (performance!)
- Generally not purely functional

<pre><code class="scala" data-trim contenteditable>
def country(cityCode: String): String = {
  try {
    cities(cityCode).get.country
  } catch {
    Log.warn(s"Unexpected city $cityCode")
    "UnknownCountry"
  }
}
</code></pre>

<!--slide-down-->

### When to use?

Not really appealing:

- Requires the use of RM tools to retrieve logs (as not in HDFS)
- Difficult to test
- However provides by default multiple levels of seriousness


<!--slide-next-->

## The `Try` / `Either` approach

Return `Try` / `Either` types always.

- Purely functional
- `Exception` reports are part of the output of a transformation

<pre><code class="scala" data-trim contenteditable>
def country(cityCode: String): Try[String] = {
  Try{cities(cityCode).get.country}
}
</code></pre>

<!--slide-down-->

### When to use?

Maybe the most appealing approach:

- Results are stored in HDFS
- Easy to test
- Easy to reason about
- Spark/Hadoop agnostic
- Can be tricky to save simultaneously `Success`/`Right` and `Failure`/`Left` sides (could be slow, requiring multiple actions to be triggered)
- Does not provide support for levels of seriousness

<!--slide-next-->

## The Accumulator approach

Use the Spark `Accumulator` mechanism to report statistics on specific scenarios.

- Not meant to retrieve detailed information about the failure
- Function argument is mutable (often seen as bad practice)

<pre><code class="scala" data-trim contenteditable>
def country(cityCode: String, ac: Accumulator): String = {
  cities(cityCode) match {
    case Some(city) => city.country
    case None => {ac += 1; "UnknownCountry"}
  }
}
</code></pre>

<!--slide-down-->

### When to use?

The Spark approach:

- Results can be printed in `stdout` or stored in HDFS easily
- Relatively easy to test
- Spark framework dependant
- Should be very fast
- Does not provide support for levels of seriousness

<!--slide-next-->

## More evolved approaches

Will be in a different post.

# Enjoy!

If you have any comments, let me know!


