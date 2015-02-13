---
layout: post
title: Changing the I/O scheduler for a specific disk
comments: true
tags:
- Fedora
- I/O Scheduler
- Noop
- Queue
- Scheduler
- Systemd
---
Today, I have [read][io-scheduler-switch] that switching the default I/O scheduler from `cqf` to `noop` is benefit for Solid State Drives (SSD). Since I got an SSD recently, achieving this configuration was one of my concerns.

<!--more-->

Changing permanently the I/O scheduler for a specific disk is really easy. It can be realized by executing the following shell command as root:

{% highlight console %}
echo {SCHEDULER-NAME} > /sys/block/{DEVICE-NAME}/queue/scheduler
{% endhighlight %}

where {SCHEDULER-NAME} is either the value `cfq`, `noop` or `deadline` and {DEVICE-NAME} the name of your device (e.g. sda). In my case, I used the `noop` scheduler since it is the one that implies no reordering for I/O requests. Indeed, in contrary to Hard Disk Drives (HDD), SSD are not mechanical and don't require to physically move heads for reads and writes. Consequently, reordering I/O requests is a waste of CPU time, which eventually decreases throughput and increases latency.

Once applied you can check the change with:

{% highlight console %}
cat /sys/block/{DEVICE-NAME}/queue/scheduler
{% endhighlight %}

However, the change is lost after a reboot. If you are using systemd (e.g on Fedora 20), which is a system and service manager service, a specific unit may be written to apply your configuration at each reboot.

You simply have to create a file in /etc/systemd/system/io-scheduler.service with the following content:

{% highlight console %}
[Unit]
Description=I/O Scheduler Setter
After=local-fs.target
[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo noop > /sys/block/sda/queue/scheduler'
TimeoutSec=0
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
{% endhighlight %}

Then, enable the service for auto start at boot and start it for the current session with:

{% highlight console %}
chmod 755 /etc/systemd/system/io-scheduler.service
systemctl enable io-scheduler.service
systemctl start io-scheduler.service
{% endhighlight %}


[io-scheduler-switch]: https://wiki.archlinux.org/index.php/Solid_State_Drives#I.2FO_Scheduler
