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

# Enumeratum

Enumerations for _Scala_

<!--slide-down-->
 
## Why should I care?

<!--slide-down-->

- Enumerations are the basis of programming
- You ambition **less maintenance**
  - Find bugs at compile time
  - Code easy to understand
  - Meaningful data types

_"Let the compiler help you!!!"_

<!--slide-down-->

- Many code smells come from enums
  - [Primitive obsession](https://refactoring.guru/smells/primitive-obsession) (`readMode: String`)
  - [Change preventers](https://refactoring.guru/refactoring/smells/change-preventers)
- _Scala 2_ native enums are **flawed**

<!--more-->

<!--slide-next-->

## Enumerations

- How to code them in Scala?

<!--slide-next-->

## What to wish?

<img src="https://i.pinimg.com/236x/29/06/1e/29061ea2855d7036d66507a674e799eb--macarons-th-birthday.jpg" height="300" width="300">

<!--slide-down-->

- Exhaustive pattern matching (**safety**)
- No type erasure (**method overloading**)
- Default methods for (safe) **serialization/deserialization**
- **List all** possible values
- Values to have **extra fields**
- Values to be provided an **ordering**

(from [here](https://pedrorijo.com/blog/scala-enums/))

<!--slide-next-->

### 1. Using `scala.Enumeration`

```
object Color extends Enumeration {
  val Red, Green, Blue = Value
}
```

<!--slide-down-->

#### Evaluation

<!--slide-down-->

- (+) native
- (-) No exhaustiveness checks

```
def asString(c: Color.Value) = c match {
  case Color.Blue => "blue"
  // and other colors??? (!!!)
}
// no warning, nothing...
```

<img src="https://pngimage.net/wp-content/uploads/2018/06/oh-my-god-png-8.png" height="200" width="200">

<!--slide-down-->

- (-) Cannot do method overloading (type erasure)

```
def take(c: Color.Value)
def take(c: Animal.Value)
// take(Enumeration.this.Value)Unit is 
//   already defined in the scope
```

<img src="https://www.kindpng.com/picc/b/88/883319.png" height="300" width="300">

<!--slide-down-->

(on serialization / deserialization)

- (+) Built-in `.toString`
- (-) Its `.withName` method is mean

```
Color.withName("chucknorris")
// throws NoSuchElementException... 
// :. No referentially transparent
```

<!--slide-down-->

- (+) Easy to list all values (`Color.values`)
- (+) Values are provided an ordering
- (-) Does not support extra fields

```
// Could not code this:
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

- (+) _Scala 2_ **native**
- (+) **Exhaustive** pattern matching
- (+) **No type erasure**
- (-) Missing `.withName` method
- (-) Missing `.values` method
- (+) Values can have **attributes**
- (+) Values can have **functions**
- (-) Values are not provided with an ordering


<!--slide-next-->

### 3. Switching to Scala 3

  - Scala 3 / `dotty` addresses this issue
    - See [this](http://dotty.epfl.ch/docs/reference/enums/enums.html) for more info
    - (-) Scala 3 [not ready](https://dotty.epfl.ch/docs/)!

<!--slide-next-->

### 4. Using `enumeratum`

- (~) [A library](https://github.com/lloydmeta/enumeratum)
  - (+) No dependencies
- (+) **Exhaustive** pattern matching
- (+) **No type erasure**
- (+) Provides **`.withName` method**
- (+) Provides **`.values` method**

<!--slide-down-->

- (+) Values can have **attributes**
- (+) Values can have **methods**
- (+) Values are provided an **ordering**
- (+) **Faster** than `scala.Enumeration` (from the standard library!)
- (+) **Integration with pureconfig**, among other libs
- (+) And more!

<!--slide-down-->

#### Examples I

Plain example: 

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

#### Examples II

Values with attributes: [here](https://github.com/mauriciojost/main4ino-server/blob/master/src/main/scala/org/mauritania/main4ino/security/Permission.scala#L11)

<!--slide-down-->

#### Examples III

[Pureconfig](https://github.com/pureconfig/pureconfig) integration: [here](https://github.com/mauriciojost/main4ino-server/blob/master/src/main/scala/org/mauritania/main4ino/security/Permission.scala)

<!--slide-next-->

## Thanks!

<!--slide-next-->

## Other posts

- [From Pedro Rijo](https://pedrorijo.com/blog/scala-enums/)

