---
layout: post
title:  "CoVariant, ContraVariant and InVariant... Variances in Scala"
date:   2017-10-10 00:00:00 +0200
tags:
- scala
- types
- covariant
- contravariant
- invariant
comments: true
---

As a newbie in Scala I've struggled to understand what `covariance`, `contravariance` and `invariance` in Scala mean.

After some reading, I thought I got somewhere, so I wanted to share it with you.

![Alt text](https://g.gravizo.com/svg?
@startuml;
skinparam monochrome false;
caption Figure 1. Use of Covariance and Contravariance;
scale max 900 width;
Animal <|-- Dog;
Animal <|-- Cat;
"List[Animal]" <|-- "List[Dog]": "Covariance [+A]";
"List[Animal]" <|-- "List[Cat]";
"Funct[Animal]" --|> "Funct[Dog]": "Contravariance [-A]";
@enduml;
)

<!--more-->

## The problem 

Consider the following example. 

Let's say I work for a veterinary, and I am writing an API to modularize the functions that allow to retrieve pets' information from a database.
For instance, it should be possible to provide functions `getName` or `getBreed`, etc.

I could do it by implementing a class `Fun` (as in **fun**ction) that encapsulates a function, with attribute `f` that will work as an _information retriever_. 

Here it is our first attempt: 

```scala
class Fun[I,O](val f: I => O) {
  def apply(i: I): O = f(i)
}
```

Now let's imagine we have to make our functions operate on the following classes:

```scala
// Our pet classes
sealed class Animal
class Dog extends Animal
class Cat extends Animal
```

Good! We can define our first instance of `Fun`, that tells if our animal is a dog:

```scala
// Our first information retriever
val isADog: Fun[Animal, Boolean] =
        new Fun((i: Animal) => i.isInstanceOf[Dog])
```

We say that **_Fun_ is invariant in `I` (`Animal`) and invariant in `O` (`Boolean`)**, as there is not subtype association
done by the compiler.

## Generalizing `Fun`: Covariance

### The problem

Let's say I have managed to collect many _information retrievers_: 

```scala
val x:  Fun[Animal, Boolean] = ...
val y:  Fun[Animal, String] = ...
val z:  Fun[Animal, Int] = ...
```

I would like to treat all `x`, `y` and `z` polymorphically, for instance storing them in a `List[Animal, AnyVal]`. Our initial declaration
of `Fun[I, O]`, invariant in both `I` and `O`, does not allow this.

This is where **covariance** becomes handy.

### The solution

The solution is covariance. The principle: making `Clz` covariant in `A` means that
if `Cat <: Animal`, then `Clz[Cat] <: Clz[Animal]`. In other words the inheritance of
this parametric type follows the one from the parameter type.

To do it, we simply re-define `Fun`, but making it covariant in `O`:

```scala
class Fun[I, +O](val f: I => O) { // now covariant on O
  def apply(i: I): O = f(i)
}
val covariantIsDog: Fun[Animal, Boolean] =          // specific type
        new Fun((i: Animal) => i.isInstanceOf[Dog])

val covariantIsDogForAnyVal: Fun[Animal, AnyVal] =  // generic type
        covariantIsDog // assigned to a more general type
                       // works because
                       // Boolean <: AnyVal, and thanks
                       // to covariance
                       // Fun[_, Boolean] <: Fun[_, AnyVal]

covariantIsDog(myDog) // returns true
covariantIsDogForAnyVal(myDog) // returns true
```

## Specializing `Fun`: Contravariance

### The problem

Let's say we have our function `Fun[Animal, Boolean]`. Given that `Dog <: Animal` (`Dog` is a subtype of `Animal`),
it seems natural to be able to apply such function to a `Dog` too.

This is where **contravariance** becomes handy.

### The solution

The solution is contravariance.

The principle: making `Clz` contravariant in `A` means that
if `Cat <: Animal`, then `Clz[Cat] >: Clz[Animal]`. In other words the inheritance of
this parametric type follows inversely the one from the parameter type. It allows
for specialization.

We simply re-define `Fun` but making it contravariant in `I`:

```scala
class Fun[-I, O](val f: I => O) { // now contravariant in I
  def apply(i: I): O = f(i)
}
val contravariantIsDog: Fun[Animal, Boolean] =    // generic type
        new Fun((i: Animal) => i.isInstanceOf[Dog])

val contravariantIsDogForDog: Fun[Dog, Boolean] = // specific type
        contravariantIsDog // assigned to a more specific type
                           // works because
                           // Dog <: Animal, and thanks
                           // to contravariance
                           // Fun[Dog, _] >: Fun[Animal, _]

contravariantIsDogForDog(myDog) // returns true
```

## More Information

See the [official Scala documentation on variance](https://docs.scala-lang.org/tour/variances.html).

Enjoy!
