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
---
## Why sorting?

Sorting requirements are present in the vast majority of data processing applications. As Scala provides very good tools for addressing them, I thought it would be interesting to dive a bit into them to improve our code.

Here are some of the patterns that you may feel tempted to use, and what I consider is a better alternative. Leave a comment if you have even a better one!

<!--more-->

Imagine you have the following collection (you can try this out in the scala-shell):

```scala
val l : Iterable[Int] = List(1,0,2)
```


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

Apart from being simpler and easier to read, it's also more efficient (as no intermediate collection will be created).

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

Mind though, that `Set` is not suitable if you need your collection to keep duplicate elements.

## Sorting on more complex types

The above proposal seems just too simple to be applied to other scenarios. 
What if we have more complex types? For instance: 

```scala
case class A(
   p1: Int, 
   p2: String, 
   p3: Boolean
)
val l : Iterable[A] = List(
   A(1, "a", true), 
   A(1, "c", true), 
   A(-1, "a", true)
)
```

We can say that *there is no implicit Ordering defined for A*. As A is part of our business, 
it’s up to us to define its *Ordering*, which we can do easily as follows: 

```scala
val orderingOnP1: Ordering[A] = Ordering.by(a => a.p1)
l.min(orderingOnP1) // A(-1,a,true)
```

Keep in mind that there is an implicit ordering defined for the type `Int` and that's why this works. 
Scala also has an implicit ordering defined for tuples of types for which there is an implicit ordering, which includes
primitive types such as `Int`, `String`, `Double` and so on. Thanks to this we can specify a multi-field ordering with 
a given priority, as follows:

```scala
val orderingOnP1P2: Ordering[A] = 
      Ordering.by(a => (a.p1, a.p2)) // uses imp. ordering
l.max(orderingOnP1P2) // A(1,c,true)
```

Using *Orderings* your code will become much cleaner, robust, reusable and testable.

**Will you sort anything?**

