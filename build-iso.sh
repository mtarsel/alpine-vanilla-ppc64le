#!/bin/sh
#Written by Mick Tarsel
#setup the env to build a ppc64le vanilla iso

#clear it
echo >  /etc/apk/repositories

# add just what we want
echo "http://dl-5.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories
echo "http://dl-5.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories

apk add ruby alpine-sdk build-base apk-tools alpine-conf busybox fakeroot syslinux xorriso ruby git

gem install facter rake bundler --no-document

adduser build -G abuild
abuild-keygen -i -a
cp /root/.abuild/root-*.rsa.pub /etc/apk/keys
cp /root/.abuild/root-*.rsa.pub /etc/apk/keys.pub
apk update

#Written by Jeremy Adams
git clone https://github.com/puppetlabs/razor-alpine-ppc64le-mk.git
cd razor-alpine-ppc64le-mk/
bundle install
bundle exec rake build
echo 'to install: gem install --local '$(pwd)'/pkg/razor-mk-agent-*.gem --no-document' >> ../command.txt

cd ../

git clone https://github.com/mtarsel/aports.git

cd aports/scripts
mkdir gems
gem install facter --no-document -i ./gems

mkdir ~/iso

sh mkimage.sh --tag main --outdir ~/iso --arch ppc64le --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main --profile razor
