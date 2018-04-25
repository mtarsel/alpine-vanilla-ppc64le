#!/bin/sh
#Written by Mick Tarsel
#using a x86_64 install of Alpine vanilla, this script will setup the env to build a ppc64le vanilla iso

#Run this in /home/build dir!

apk add alpine-sdk xorriso syslinux
abuild-keygen -i -a
cp /root/.abuild/root-*.rsa.pub /etc/apk/keys
apk update

make PROFILE=alpine-vanilla ALPINE_ARCH=ppc64le iso
