---
layout: post
title: Videostream on Fedora 20
comments: true
tags:
- Chromecast
- Fedora
- Firewalld
- Videostream
---
Videostream is the ultimate Chromecast app. Unfortunately, Chromecast and Videostream do not work out of the box on recent Fedora versions due to firewalld: some minor configuration is required. The configuration consists in opening port ranges `32768-61000` (UDP) for Chromecast and `5550-5559` (TCP) for Videostream.

Below are the commands to enter in your terminal to complete the configuration in a few seconds:

{% highlight console %}
firewall-cmd --permanent --add-port=32768-61000/udp
firewall-cmd --permanent --add-port=5550-5559/tcp
firewall-cmd --reload
{% endhighlight %}
