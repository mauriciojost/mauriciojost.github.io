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

Variance aims to provide flexibility to the inheritance on parametric types. Example:

- It seems reasonable that `List[Dog]` extends `List[Animal]`
- It seems reasonable that I can use `X=>Boolean` as `X=>AnyVal`

<!--slide-next-->

### A concrete example

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

<!--slide-down-->

Let's say you work for a veterinary.

You're writing an API, and want to modularize the functions
that retrieve pets' information from a DB, like

- `getName`
- `getBreed`
- etc.

<!--slide-down-->

How would you do that?

<!--more-->

<!--slide-next-->

Let's first define our business classes:

```
// Our pet classes
sealed class Animal
class Dog extends Animal
class Cat extends Animal
```

<!--slide-down-->

Then, we could define a class `Fun` (as in **fun**ction) that will encapsulate an
_information retriever_ function. This is a provided function `f`.

Here is our first attempt:

```
class Fun[I,O] (val f: I => O) {
  def apply(i: I): O = f(i)
}
```

<!--slide-down-->

Good! We can define our first instance of `Fun`, that tells if our animal is a dog:

```
// Our first information retriever
val isADog: Fun[Animal, Boolean] =
        new Fun((i: Animal) =>
              i.isInstanceOf[Dog])
```

<!--slide-down-->

We say that **_Fun_ is invariant in `I` (`Animal`) and invariant in `O` (`Boolean`)**, as there is not subtype association
done by the compiler.

<!--slide-next-->

## Generalizing `Fun`: Covariance

<!--slide-down-->

### The problem

Let's say you managed to collect many _information retrievers_:

```
val x:  Fun[Animal, Boolean] = ...
val y:  Fun[Animal, String] = ...
val z:  Fun[Animal, Int] = ...
```

<!--slide-down-->

It would be good to be able to treat all `x`, `y` and `z` polymorphically, for instance storing them
in a `List[Animal, AnyVal]`.

Our initial declaration of `Fun[I, O]`, invariant in both `I` and `O`,
does not allow this.

<!--slide-down-->

This is where **covariance** becomes handy.

<!--slide-down-->

### The solution

<!--slide-ignore-begin-->

The solution is covariance. The principle: making `Clz` covariant in `A` means that
if `Cat <: Animal`, then `Clz[Cat] <: Clz[Animal]`. In other words the inheritance of
this parametric type follows the one from the parameter type.

<!--slide-ignore-end-->

To do it, we simply re-define `Fun`, but making it covariant in `O`:

<!--slide-down-->

```
// now covariant on O
class Fun[I, +O] (val f: I => O) {
  def apply(i: I): O = f(i)
}
```

<!--slide-down-->

```
// specific type
val covIsDog: Fun[Animal, Boolean] =
        new Fun((i: Animal) =>
              i.isInstanceOf[Dog])

// generic type
val covIsDogForAnyVal: Fun[Animal, AnyVal] =
        covIsDog // assigned to a more general type
                 // works because
                 // Boolean <: AnyVal,
                 // and thanks to covariance
                 // Fun[X, Boolean] <: Fun[X, AnyVal]

```

<!--slide-down-->

```
covariantIsDog(myDog) // true
covariantIsDogForAnyVal(myDog) // true
```

<!--slide-next-->

## Specializing `Fun`: Contravariance

<!--slide-down-->

### The problem

Let's say we have our function `Fun[Animal, Boolean]`. Given that `Dog <: Animal` (`Dog` is a subtype of `Animal`),
it seems natural to be able to apply such function to a `Dog` too.

<!--slide-down-->

This is where **contravariance** becomes handy.

<!--slide-down-->

### The solution

The solution is contravariance.

<!--slide-ignore-begin-->

The principle: making `Clz` contravariant in `A` means that
if `Cat <: Animal`, then `Clz[Cat] >: Clz[Animal]`. In other words the inheritance of
this parametric type follows inversely the one from the parameter type. It allows
for specialization.

<!--slide-ignore-end-->

<!--slide-down-->

We simply re-define `Fun` but making it contravariant in `I`:

```
// now contravariant in I
class Fun[-I, O] (val f: I => O) {
  def apply(i: I): O = f(i)
}
```

<!--slide-down-->

```
// generic type
val contravariantIsDog: Fun[Animal, Boolean] =
        new Fun((i: Animal) => i.isInstanceOf[Dog])

// specific type
val contravariantIsDogForDog: Fun[Dog, Boolean] =
        contravariantIsDog // assigned to a more specific type
                           // works because
                           // Dog <: Animal, and thanks
                           // to contravariance
                           // Fun[Dog, _] >: Fun[Animal, _]

```

<!--slide-down-->

```
contravariantIsDogForDog(myDog) // returns true
```

<!--slide-next-->

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

<!--slide-next-->

## More Information

See the [official Scala documentation on variance](https://docs.scala-lang.org/tour/variances.html).

<!--slide-next-->

Enjoy!
