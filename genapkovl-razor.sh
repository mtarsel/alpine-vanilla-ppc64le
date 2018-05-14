#!/bin/sh -e

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
	echo "usage: $0 hostname"
	exit 1
fi

cleanup() {
	rm -rf "$tmp"
}

makefile() {
	OWNER="$1"
	PERMS="$2"
	FILENAME="$3"
	cat > "$FILENAME"
	chown "$OWNER" "$FILENAME"
	chmod "$PERMS" "$FILENAME"
}

rc_add() {
	mkdir -p "$tmp"/etc/runlevels/"$2"
	ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

mkdir -p "$tmp"/etc
makefile root:root 0644 "$tmp"/etc/hostname <<EOF
$HOSTNAME
EOF

mkdir -p "$tmp"/etc/network
makefile root:root 0644 "$tmp"/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

mkdir -p "$tmp"/etc/apk
makefile root:root 0644 "$tmp"/etc/apk/world <<EOF
alpine-base
bkeymaps
alpine-base
alpine-mirrors
network-extras
openssl
openssh
chrony
tzdata
ruby
ruby-rake
ruby-bundler
net-tools
EOF

#/etc/apker exists on build machine
#/etc/gems and /etc/razor will be on machine we want to get info for
mkdir -p "$tmp"/etc/gems
cp /etc/apker/my-gems/*.gem "$tmp"/etc/gems

#/etc/razor contains scripts to start service
mkdir -p "$tmp"/etc/razor
cp /etc/apker/mk* "$tmp"/etc/razor

mkdir -p "$tmp"/etc/profile.d/                                
makefile root:root 0755 "$tmp"/etc/profile.d/rubski.sh <<EOF  
#!/bin/sh

echo "Installing local gems from /etc/gems ..."

/usr/bin/gem install --local /etc/gems/*.gem --no-document

echo "Gems installed. Starting Razor service...."

chmod +x /etc/razor/mk
chmod +x /etc/razor/mk-register
chmod +x /etc/razor/mk-update

mv /etc/razor/mk-* /usr/local/bin

EOF

rc_add devfs sysinit
rc_add dmesg sysinit
rc_add mdev sysinit
rc_add hwdrivers sysinit
rc_add modloop sysinit

rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot

rc_add networking boot

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

tar -c -C "$tmp" etc | gzip -9n > $HOSTNAME.apkovl.tar.gz
