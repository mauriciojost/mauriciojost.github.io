---
layout: post
title:  "Sorting Anything Cleanly with Scala"
date:   2017-03-01 00:00:00 +0200
tags:
- scala 
- sorting 
- orderings 
- api 
- max 
- min
comments: true
disqusid: sortingordering
---
## Why sorting?

Sorting requirements are present in the vast majority of data processing applications. Think of questions like:

- what are the last 5 cities visited by a passenger?

- what is the least profitable product being sold?

- what is the first snapshot of a hotel booking?

All will end up coded with some kind of sorting algorithm under the hood, and Scala provides very good tools for answering them. 

Imagine you have the following collection (you can try this out in the scala-shell):

```scala
val l : Iterable[Int] = List(1,0,2)
```

Here are some of the patterns that we may feel tempted to use, and what I personally consider is a better alternative:

## Basic sorting 

### Get an extreme value from a collection

If you feel tempted to do:

```scala
val max = l.toSeq.sorted.last
```

you better do: 

```scala
val max = l.max
```

Apart from being simpler, it's also more efficient (as no intermediate collection will be created).

### Sort a collection even after updates

If you feel tempted to do:

```scala
val seq = l.toSeq
val l2 = seq :+ 5
val sorted2 = l2.sorted
val l3 = sorted2 :+ 6
val sorted3 = l3.sorted
```

you better do: 

```scala
import scala.collection.SortedSet
val s = SortedSet.empty[Int] ++ l
val sorted2 = s + 5 // sorted
val sorted3 = s + 6 // sorted
```

Apart from being cleaner, it's also more efficient as (no intermediate non-sorted collections are created).

## Sorting on more complex types

The above proposal seems just too simple to be applied to other scenarios. What if we have more complex types? For instance: 

```scala
case class A(p1: Int, p2: String, p3: Boolean)
val l : Iterable[A] = List(A(1, "a", true), A(1, "c", true), A(-1, "a", true))
```

We can say that *there is no Ordering defined for A*. As A is part of our business, it’s up to us to define its *Ordering*, which we can do easily as follows: 

```scala
val orderingOnP1: Ordering[A] = Ordering.fromLessThan(_.p1  (a.p1, a.p2)) // uses imp. ordering
l.max(orderingOnP1P2) // A(1,c,true)
```

Using *Orderings* your code will become much cleaner, reusable and testable.


