---
layout: post
title:  "Partial Functions in Scala"
date:   2016-09-01 00:00:00 +0200
tags:
- scala 
- partial 
- functions 
- collect
- collections
comments: true
---
##  What is a partial function?

In short, a partial function is simply a mathematical function *f: X->Y* that is not defined for some elements in the domain *X*.

The typical example is *f: 1/x* , not defined when *x = 0*.

## But, what is a partial function in Scala?

It is a Scala trait that allows to express a partial function. For instance...

<!--more-->

The previous example would be expressed as: 

```scala
val div = new PartialFunction[Int, Int] {
    def apply(x: Int) = x
    def isDefinedAt(x: Int) = x > 0
}
```

Or more concisely (using pattern matching):

```scala
val positives: PartialFunction[Int, Int] = {
    case x: Int if x > 0 => x
}
```

## Why should I use it?

### Because they are extensively used in the Scala API

Really. For instance, the root of all collections (the trait Traversable) defines the method

```scala
def collect[Y](pf: PartialFunction[X, Y]): Traversable[Y]
```

that allows to create a List[Y] from some elements of a List[X]. Knowing the API will let you have more choices when tackling a problem and surely be a better developer.

### Because they are efficient

Consider the function *f: x.toString* where *x > 0* similar to the one I mentioned above. This could be expressed as: 

```scala
val positivesAsStrings = numbers.filter(n => n > 0).map(x => x.toString)
```

But there is something nasty about it. After the filter call, Scala will create an intermediate collection on which it will apply the map call. If your intermediate collection is large (let’s say you have a million of integers and a high percentage is positive) you will waste time creating this discardable intermediate object.
However, if using collect(partialFunction) instead, we will be populating the the final collection right away. Think of the amount of garbage collection you could save!

```scala
val positivesAsStringsPF: PartialFunction[Int, String] = {
    case x: Int if x > 0 => x.toString
}

val positivesAsStrings = numbers.collect(positivesAsStringsPF)
```

### Because they ease modularization and can be combined

When using pattern matching we use blocks like this one:

```scala
val result: String = parameter match {
    case Some(p) => asString(p)
    case None => “default”
}
```

Here we provide the domain on which we want to apply a function (on defined monads, and also undefined monads in this case), and the function itself for each case. For the sake of modularization, this can be expressed as a set of partial functions combined together:

```scala
val pfForSome: PartialFunction[Int, String] = {
    case Some(p: Int) => asString(p)
}

val pfForNone: PartialFunction[Int, String] = {
    case None => default
}

val pfForSomeAndNone: PartialFunction[Int, String] = 
   pfForSome.orElse(pfForNone)

val resultAsOption: Option[String] = parameter.collect(pfForSomeAndNone)
```

## Want to know more?

[I really liked this post](http://blog.bruchez.name/2011/10/scala-partial-functions-without-phd.html), I encourage you to take a look.

**Won't you partial-function-ize anything?**

