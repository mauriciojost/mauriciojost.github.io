---
layout: [presentation, post]
title:  "Arduino: Finally getting started"
date:   2020-04-30 00:00:00 +0200
reveal:
  theme: ../../../css/theme/whiteish
  center: true
  history: true
  tableofcontents: true
tags:
- arduino 
- newbie
- esp8266
comments: true
---

# Arduino

<!--slide-ignore-begin-->

I always wanted to write a post with some sort of help for those curious about the fascinating world of Arduino. Here it is. Finally my getting started guide.

<!--slide-ignore-end-->

<!--slide-down-->

Please, stay only if...

- you're **curious**
- you're looking for **new hobbies**
- you have some **programming skills**
- you're at **no risk of divorce**

<!--slide-ignore-begin-->

A **real disclaimer**, arduino is a time sucker, same level as:

- 3D printing, 
- video games,
- aeromodelling, 
- etc.

**Be careful**.

<!--slide-ignore-end-->

<!--slide-next-->

<!--more-->

## What is Arduino?

**Company and a community** that designs and manufactures **single-board microcontrollers** and microcontroller kits for building **digital devices** <_with the **framework to program them**_>.

<!--slide-next-->

## Uses for Arduino

Mostly pocket-sized devices with:

- A specific purpose (_embedded system_)
- A minimalistic or no user interface
- _High_ power efficiency
- Need for portability
- Low price
- _No Operating System_ needed

NOTE: For those more into it already, keep in mind that all the items above are indicative. Sure you can have an arduino with 3 simple purposes, the user interface could be a color LCD still, maybe not efficient if you use no sleep features, no portability if you have a automatic window opening system, price can vary if you have a very expensive sensor, there are some so called operating systems for Arduino like Mongoose OS, ...

<!--slide-down-->

## And Raspberry?

- Also a pocket-size board
- It's a full computer though
- **Has an Operating System**
- More expensive than most Arduino boards (~30€ the cheapest on [amazon.fr](https://www.amazon.fr/Raspberry-Plaque-mod%C3%A8le-Cortex-11811853/dp/B07KKBCXLY/ref=sr_1_3?__mk_fr_FR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=raspberry+pi&qid=1588318997&sr=8-3))
- **could last a day** on batteries (maximum)

**OUT OF SCOPE**

NOTE: Saw some videos making a big deal out of a Raspberry running on batteries for 14 hours.

<!--slide-down-->

## And the rest?

- FPGA
- ESPuma
- uPython
- Blynk
- Mongoose OS
- ...

**OUT OF SCOPE**

<!--slide-next-->

## Why is it all interesting?

<!--slide-down-->

- Boards can be way cheaper than a laptop
- Lots of cool applications (IoT)
  - Smart Home
  - Smart City
  - Environment
  - Security
  - Industrial IoT
  - ...

<!--slide-down-->


- Wider scope than just programming
- Interact with the real world / physics
  - Actuators
  - Sensors
- Build something useful
- Be creative
- Think out of the box
- Have fun

<!--slide-next-->

## How to get started

<!--slide-down-->

### Main ingredients

1. An arduino-compatible board
2. Some sensor/s
3. Some user interface/s
4. A power supply
5. A firmware

<!--slide-down-->

Proposed ingredients (**to buy**):


1. Board: [**NodeMCU esp8266** (~5€)](https://www.amazon.fr/Yizhet-NodeMCU-ESP8266-ESP-12E-D%C3%A9veloppement/dp/B07XJWK5F4/ref=sr_1_3?dchild=1&keywords=ESP8266+nodeMCU&qid=1588339084&sr=8-3)
2. Sensor: [**a button** (~3€ each)](https://www.amazon.fr/dp/B07DPSMRJ6/ref=cm_sw_em_r_mt_)
3. UI: [**some leds** (~3€)](https://www.amazon.fr/dp/B07PR5T67K/ref=cm_sw_em_r_mt_dp_U_NncREbE6NZ3Q3)
4. Power: laptop [(+ **an usb cable** (~3€))](https://www.amazon.fr/dp/B0711PVX6Z/ref=cm_sw_em_r_mt_)
5. Firmware: [blinking led](https://github.com/mauriciojost/esp8266-blinking-led) using [PlatformIO](https://platformio.org/)

_The component aboves are not the cheapest, but the simplest to get started with!!!_

<!--slide-next-->

### Procedure

<!--slide-down-->

1. Install it from [here](https://docs.platformio.org/en/latest/core/installation.html)
2. (optional) Install the IDE from [here](https://platformio.org/platformio-ide)
3. See the documentation [here](https://docs.platformio.org/en/latest/core/index.html)

<!--slide-down-->

4. Connect your laptop to the **NodeMCU esp8266** using the **usb cable**
5. Clone the [blinking led](https://github.com/mauriciojost/esp8266-blinking-led) project
6. Connect the leds to the board as described in [the Pinout.h header](https://github.com/mauriciojost/esp8266-blinking-led/blob/master/src/Pinout.h)
7. Launch `platformio run --target upload` to upload it to the board

<!--slide-down-->

## Sensors

- Other transductors: 
  - temperature
  - luminosity
  - humidity
  - pressure
  - rfid
  - mic
  - buttons
  - motors
  - servos
  - lasers

<!--slide-next-->

## In my pipeline

<!--slide-down-->

<!--more-->
 
<!--slide-down-->

