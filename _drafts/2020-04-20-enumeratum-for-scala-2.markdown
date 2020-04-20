---
layout: [presentation]
title:  "Quicky on Enumeratum for Scala 2"
date:   2020-04-20 00:00:00 +0200
reveal:
  theme: ../../../css/theme/whiteish
  center: true
  history: true
tags:
- scala 
- enumeratum
- enum
comments: true
---
 
## Enumeratum: why should I care?

- Scala 2 native enums are **flawed**
- you want to **be safe** (type safety)
- you depend on **pattern matching**
- you need **less maintenance**

<!--more-->
<!--slide-next-->

## What is an ADT?

**Algebraic Data Type**

- Two basic categories
  - **Sum types** (enums)
  - **Product types** (case classes)

[(more info)](https://nrinaudo.github.io/scala-best-practices/definitions/adt.html)

<!--slide-next-->

## Let's focus on **Sum types**

- How to code them?
- There are many ways...

<!--slide-next-->

### 1. Using `scala.Enumeration`

```
object Color extends Enumeration {
  val Red, Green, Blue = Value
}
```

<!--slide-down-->

#### Drawbacks I

- Cannot do method overloading

```
def take(c: Color)
def take(c: Animal)
// Error: double definition ...
```

<!--slide-down-->

#### Drawbacks II

- Do not benefit from exhaustiveness checks

```
color match {
  case Red => "red"
}
// no warning, nothing...
```

<!--slide-down-->

#### Drawbacks III

- Its `withName` method is mean

```
Color.withName("chucknorris")
// NoSuchElementException
```

<!--slide-down-->

#### Drawbacks IV

- Does not support extra fields

```
//       r g b
// Red   1 0 0 
// Green 0 1 0
// Blue  0 0 1
```

[(more details)](https://medium.com/@yuriigorbylov/scala-enumerations-hell-5bdba2c1216)

<!--slide-next-->

### 2. Using Scala `sealed case`

```
sealed abstract class Color(
  val r: Float,
  val g: Float,
  val b: Float
)
object Color extends Enum {
  case object Red   extends Color(1, 0, 0)
  case object Green extends Color(0, 1, 0)
  case object Blue  extends Color(0, 0, 1)
}
```

<!--slide-down-->

#### Drawbacks

- no parsing (missing `Color.withName`)
- no listing (missing `Color.values`)

<!--slide-next-->

### 3. Switching to Scala 3

  - Scala 3 / `dotty` addresses this issue, see [this](http://dotty.epfl.ch/docs/reference/enums/enums.html) for more info)

<!--slide-next-->

### 4. Using `enumeratum`

- [A library](https://github.com/lloydmeta/enumeratum)
- No dependencies
- Faster than `scala.Enumeration` (from standard library!)
- Enums can be objects with methods, attributes, etc.
- No use of reflection at runtime (so fast)
- ... others

<!--slide-down-->

#### Examples

[See here](https://github.com/mauriciojost/main4ino-server/blob/master/src/main/scala/org/mauritania/main4ino/security/Permission.scala)

<!--slide-next-->

## Thanks!



