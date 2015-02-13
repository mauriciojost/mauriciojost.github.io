---
layout: post
title: '"Unfortunately, Launcher has stopped" on Android'
comments: true
tags:
- ADB
- Android
- Android Virtual Device
- AVD
- Crash
- Error
- logcat
- Lollipop
- OutOfMemory
---

I am discovering Android emulators. My purpose is to automate screenshots capture for one of my apps (which will probably be the subject of another post). What was my astonishment when I started my first Android virtual device (running Lollipop) is that every time I was clicking on the app launcher icon I was getting "Unfortunately, Launcher has stopped."

<!--more-->

To fix the issue, my idea was to look at the logs provided by logcat with `adb -e logcat`. The `-e` option is used in my case for directing the adb command to the only running emulator instance since I often let one or more physical devices plugged.

Running the previous command displays many information but if you look at log messages corresponding to the time at which the app launcher icon was clicked, a really meaningful message is available:

{% highlight console %}
E/AndroidRuntime( 1794): FATAL EXCEPTION: main
E/AndroidRuntime( 1794): Process: com.android.launcher, PID: 1794
E/AndroidRuntime( 1794): java.lang.OutOfMemoryError: Failed to allocate a 13063692 byte allocation with 4194304 free bytes and 9MB until OOM
{% endhighlight %}

Indeed, the issue comes from memory allocation. To fix the problem you simply have to increase the vm heap size associated to the virtual device (in my case to 256 from 64 MB). You can do it through the graphical interface (Android Studio or by executing `android avd`). Another alternative is to edit the line `vm.heapSize=64` from the configuration file corresponding to the virtual device you have created. This file is located at `~/.android/avd/AVD_NAME.avd/config.ini` where AVD_NAME is the name of the virtual device you have created.
