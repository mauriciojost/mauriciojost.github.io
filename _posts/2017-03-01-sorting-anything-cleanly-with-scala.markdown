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

## Basic sorting

Let's use the below as our example collection (you can try this out in the scala-shell):

```scala
val l : Iterable[Int] = List(1,0,2)
```

### Get an extreme value: `max`

If you feel tempted to do:

```scala
val max = l.toSeq.sorted.last
```

just don't, **you better do**:

```scala
val max = l.max
```

**Why?**

Apart from being simpler and easier to read, it's also more efficient
(as no intermediate collection will be created).

### Keep sorted

Some usecases require to keep a collection sorted at all times.

If you feel tempted to do:

```scala
val seq = l.toSeq
val l2 = seq :+ 5
val sorted2 = l2.sorted
val l3 = sorted2 :+ 6
val sorted3 = l3.sorted
```

just don't, **you better do**:

```scala
import scala.collection.SortedSet
val s = SortedSet.empty[Int] ++ l
val sorted2 = s + 5 // sorted
val sorted3 = s + 6 // sorted
```

**Why?**

Apart from being cleaner, it's also more efficient as (no intermediate non-sorted collections are created).

Mind though, that `Set` is not suitable if you need your collection to keep duplicate elements.

## Sorting complex types: `Ordering`

Many scenarios with more complex types require some sort of functional definition of the ordering.

What if we have more complex types? For instance: 

```scala
case class Person(
   savings: Int,
   surname: String,
   hasKids: Boolean
)
val l : Iterable[Person] = List(
   Person(1, "Adam", true),
   Person(1, "Charles", true),
   Person(-1, "Adam", true)
)
```

We can say that *there is no implicit Ordering defined for Person*. As Person is part of our business,
it’s up to us to define its *Ordering*, which we can do easily as follows: 

```scala
val orderingOnSavings: Ordering[Person] = Ordering.by(p => p.savings)
l.min(orderingOnSavings) // Person(-1, "Adam", true)
```

Keep in mind that there is an implicit ordering defined for the type `Int` and that's why this works. 
Scala also has an implicit ordering defined for tuples of types for which there is an implicit ordering, which includes
primitive types such as `Int`, `String`, `Double` and so on.

Thanks to this we can specify a multi-field ordering with a given priority, as follows:

```scala
val orderingOSavingsAndSurname: Ordering[Person] =
      Ordering.by(a => (a.savings, a.surname)) // uses imp. ordering
l.max(orderingOSavingsAndSurname) // Person(1, "Charles", true)
```

Using **Orderings** your code will become:
 - much cleaner,
 - robust,
 - reusable and
 - testable

# Enjoy!

