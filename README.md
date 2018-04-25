# alpine-vanilla-ppc64le
Build Alpine Linux iso for ppc64le

# How to Run

## Install Alpine Vanilla x86_64

Run the setup-alpine script 

## Setup Environment to Build ISO

Create a build user and clone this repo in the new home dir

```bash
adduser build -G abuild

cd /home/build

git clone https://github.com/mtarsel/alpine-vanilla-ppc64le.git

cd alpine-vanilla-ppc64le

./build-iso.sh
```

https://wiki.alpinelinux.org/wiki/How_to_make_a_custom_ISO_image

