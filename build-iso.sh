#!/bin/sh
#Written by Mick Tarsel
#setup the env to build a ppc64le vanilla iso

apk add alpine-sdk build-base apk-tools alpine-conf busybox fakeroot syslinux xorriso 
adduser build -G abuild
abuild-keygen -i -a
cp /root/.abuild/root-*.rsa.pub /etc/apk/keys
cp /root/.abuild/root-*.rsa.pub /etc/apk/keys.pub
apk update

git clone https://github.com/mtarsel/aports.git

cd aports/scripts
mkdir gems
gem install facter --no-document -i ./gems

mkdir ~/iso

sh mkimage.sh --tag main --outdir ~/iso --arch ppc64le --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --profile razor
