---
layout: post
title:  "Docker: SELinux is not supported with the BTRFS graph driver!"
comments: true
tags:
- Btrfs
- Docker
- Fedora
- Linux
- Linux Containers
- LCX
- SeLinux
---

The first time I have succeeded to start a [Docker][docker] container my reaction was: "Ouawwww, incredibly simple and fast!". However, before having this feeling I have faced a failure while trying to start the docker daemon : "SELinux is not supported with the BTRFS graph driver!".

<!--more-->

This is a [known issue][known-issue] for systems running a BTRFS filesystem. Hopefully a workaround exists. It consists in editing `/etc/sysconfig/docker` to replace `OPTIONS='--selinux-enabled'` by `OPTIONS='--selinux-enabled=false'`.

Once the update made, you have to restart the daemon.

[docker]:        https://www.docker.com/
[known-issue]:   https://github.com/docker/docker/issues/7952
