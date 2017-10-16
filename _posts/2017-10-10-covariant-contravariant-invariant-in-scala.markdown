---
layout: [post, presentation]
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

## The problem 

Consider the following example:

<span style="display:block;text-align:center">![Alt text](https://g.gravizo.com/svg?
@startuml;
skinparam monochrome false;
caption Figure 1. Example types;
scale max 900 width;
Animal <|-- Dog;
Animal <|-- Cat;
@enduml;
)

Let's say I work for a veterinary, and I am writing an API. I want to modularize the functions that allow to retrieve pets' information from a database.
For instance, it should be possible to provide functions `getName` or `getBreed`, etc. 

How would you do that?

<!--nextslide-->

<!--more-->

Let's first define our business classes:

```scala
// Our pet classes
sealed class Animal
class Dog extends Animal
class Cat extends Animal
```

Then, we could define a class `Fun` (as in **fun**ction) that will encapsulate an _information retriever_ function. This is a provided function `f`. 

Here it is our first attempt: 

```scala
class Fun[I,O](val f: I => O) {
  def apply(i: I): O = f(i)
}
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

## Summary

This is the result of applying variances:

<span style="display:block;text-align:center">![Alt text](https://g.gravizo.com/svg?
@startuml;
skinparam monochrome false;
caption Figure 2. Covariance and Contravariance;
scale max 900 width;
"List[Animal]" <|-- "List[Dog]": "Covariance [+A]";
"List[Animal]" <|-- "List[Cat]";
"Funct[Dog]" <|-- "Funct[Animal]": "Contravariance [-A]";
note left of "Funct[Animal]": When instanciated,\\ncan be reused\\nas Funct[Dog]\\nthanks to\\ncontravariance;
note right of "List[Dog]": Can be added\\nto a List[Animal]\\nthanks to\\ncovariance;
@enduml;
)

## More Information

See the [official Scala documentation on variance](https://docs.scala-lang.org/tour/variances.html).

Enjoy!
