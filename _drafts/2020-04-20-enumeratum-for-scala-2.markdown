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

- Enums are useful
- Scala 2 native enums are **flawed**
- You wish to **be safe** (type safety)
- You love **pattern matching**
- You wish **less maintenance**

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

#### Evaluation I

- (-) Cannot do method overloading

```
def take(c: Color)
def take(c: Animal)
// Error: double definition ...
```
<img src="https://www.kindpng.com/picc/b/88/883319.png">

<!--slide-down-->

#### Evaluation II

- (-) No exhaustiveness checks

```
color match {
  case Red => "red"
}
// no warning, nothing...
```

<img src="https://www.pngitem.com/pimgs/m/10-104820_oh-god-why-png-oh-my-god-cartoon.png" height="300" width="300">

<!--slide-down-->

#### Evaluation III

- (-) Its `withName` method is mean

```
Color.withName("chucknorris")
// NoSuchElementException
```

<!--slide-down-->

#### Evaluation IV

- Does not support extra fields

```
// Could not code this
//       r g b
// Red   1 0 0 
// Green 0 1 0
// Blue  0 0 1
```

[(more details)](https://medium.com/@yuriigorbylov/scala-enumerations-hell-5bdba2c1216)

<!--slide-next-->

### 2. Using Scala `sealed case`

```
sealed abstract class Color
object Color extends Enum {
  case object Red   extends Color
  case object Green extends Color
  case object Blue  extends Color
}
```

<!--slide-down-->

#### Evaluation

- (+) native
- (+) supports attributes
- (+) supports functions
- (+) exhaustive pattern matching
- (-) missing `Color.withName`
- (-) missing `Color.values`

<!--slide-next-->

### 3. Switching to Scala 3

  - Scala 3 / `dotty` addresses this issue, see [this](http://dotty.epfl.ch/docs/reference/enums/enums.html) for more info)
  - Evaluation
    - (+) Great!
    - (-) Scala 3 [not ready](https://dotty.epfl.ch/docs/)!

<!--slide-next-->

### 4. Using `enumeratum`

- [A library](https://github.com/lloydmeta/enumeratum)
- No dependencies
- Faster than `scala.Enumeration` (from standard library!)
- Enums can be objects with methods, attributes, etc.
- No use of reflection at runtime (so fast)
- Integration with pureconfig, among other libs
- ... others

<!--slide-down-->

#### Examples I

```
import enumeratum._
sealed trait Color extends EnumEntry
object Color extends Enum[Color] {
  val values = findValues // magic
  case object Red extends Color
  case object Green extends Color
  case object Blue extends Color
}
```

<!--slide-down-->

#### Examples II (with attributes)

[See here](https://github.com/mauriciojost/main4ino-server/blob/master/src/main/scala/org/mauritania/main4ino/security/Permission.scala)


#### Examples III: pureconfig

[See here](https://github.com/mauriciojost/main4ino-server/blob/master/src/main/scala/org/mauritania/main4ino/security/Permission.scala)

<!--slide-next-->

## Thanks!



