#!/bin/sh
#Written by Mick Tarsel
#setup the env to build a ppc64le vanilla iso

#clear it
echo >  /etc/apk/repositories

# add just what we want
echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories

apk update

apk add ruby alpine-sdk build-base apk-tools alpine-conf busybox fakeroot xorriso ruby git

gem install facter rake bundler --no-document

adduser build -G abuild
addgroup root abuild
abuild-keygen -i -a
cp /root/.abuild/root-*.rsa.pub /etc/apk/keys
cp /root/.abuild/root-*.rsa.pub /etc/apk/keys.pub
apk update

#Written by Jeremy Adams
git clone https://github.com/puppetlabs/razor-alpine-ppc64le-mk.git
cd razor-alpine-ppc64le-mk/
bundle install
bundle exec rake build

mkdir /etc/my-gems

#all gems for .iso in /etc/my-gems
cp ./pkg/*.gem /etc/my-gems
gem install facter --no-document -i /etc/my-gems

cd ../

git clone https://github.com/alpinelinux/aports.git
cp genapkovl-razor.sh ./aports/scripts 
cp mkimg.razor.sh ./aports/scripts 

cd aports/scripts

mkdir ~/iso

sh mkimage.sh --tag main --outdir ~/iso --arch ppc64le --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main --profile razor
