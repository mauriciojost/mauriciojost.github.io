---
layout: post
title: Signing Nvidia proprietary driver on Fedora
comments: true
tags:
- Secure Boot
- Nvidia proprietary driver
- Fedora 23
- Signing kernel module
---

Two weeks ago I have upgraded my machine to Fedora 23. I fought a bit with the
installation of Nvidia proprietary driver. The main reason was that new kernel
modules to load need to be signed with a key accepted by [Secure Boot](https://docs.fedoraproject.org/en-US/Fedora/23/html/System_Administrators_Guide/sect-signing-kernel-modules-for-secure-boot.html).
Below are steps I have followed to achieve this configuration.

<!--more-->

# Creating New X.509 Key Pair

The [openssl](https://www.openssl.org) tool can be used to generate a public
and private X.509 key pair that will be used to sign a kernel module after it
has been built.

First, it is recommended to create a configuration file to pass parameters.
Hereafter is an example named _x509-configuration.ini_. Values starting by
`YOUR_` need to be replaced by your own data:

```ini
[ req ]
default_bits = 4096
distinguished_name = req_distinguished_name
prompt = no
string_mask = utf8only
x509_extensions = myexts

[ req_distinguished_name ]
O = YOUR_USERNAME
CN = YOUR_USERNAME
emailAddress = YOUR_EMAIL_ADDRESS

[ myexts ]
basicConstraints=critical,CA:FALSE
keyUsage=digitalSignature
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid
```

Then, key pair can be generated as follows:

```sh
openssl req -x509 -new -nodes -utf8 -sha256 -days 36500 -batch -config x509-configuration.ini -outform DER -out public_key.der -keyout private_key.priv
```

Output are two files: `public_key.der` and `private_key.priv`.

# Enrolling Public Key

At boot, the kernel loads Secure Boot db key database into system keyring. Since
this last is used to check which kernel modules can be loaded, the public key
`public_key.der` needs to be enrolled in this database in order to accept new
modules signed with our private key `private_key.priv`.

Usually, this operation can be achieved with _mokutil_ Fedora userspace utility:

```sh
mokutil --import mpublic_key.der
```

Unfortunately, this utility was not working for me. I was always getting
_Failed to enroll new keys_. Hopefully, it is possible to enroll a new key
from the UEFI interface, directly.

First, copy file `public_key.der` on an USB key, then restart your machine and
press the appropriate key to access your UEFI interface.

In my case the right key is _F2_. Once pressed, the UEFI interface of my
_SABERTOOTH Z97 MARK 1_ motherboard is displayed. To configure Secure Boot keys,
I clicked on _Advanced Mode_, _Boot_, _Secure Boot_ and _Key Management_.
From the panel I selected _Append default DB keys_, answered _No_ to the question
that asked if I wanted to append default DB keys. This way it asked me from
where I wanted to load keys. It allowed me to select my public key from USB key.

Once loaded, you can restart your machine. All new kernel modules signed with
the private key generated previously should be loaded with success by the
kernel.

# Signing kernel module

Move to the folder that contains the nvidia kernel module compiled. If
proprietary driver was installed by `dnf` the location should be
`/usr/lib/modules/$(uname -r)/extra/nvidia-340xx/`.

At this location, two files should be available: `nvidia.ko` and
`nvidia-uvm.ko`.

Signing both modules is as simple as follows (assuming package `kernel-devel`
is installed):

```sh
perl /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ~/private_key.priv  ~/public_key.der  nvidia.ko
perl /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ~/private_key.priv  ~/public_key.der  nvidia-uvm.ko
```

Then, module can be loaded with `insmod` and loaded modules listed with
`listmod`.
