#!/bin/sh

REL=${REL:-edge}
ARCH=${ARCH:-x86_64}
MIRROR=${MIRROR:-http://nl.alpinelinux.org/alpine}
REPO=$MIRROR/$REL/main

TMP=$(mktemp -d /tmp/alpine-docker-XXXXXXXXXX)
ROOTFS=$(mktemp -d /tmp/alpine-docker-rootfs-XXXXXXXXXX)
trap "rm -rf $TMP $ROOTFS" EXIT TERM INT

apkv() {
  curl -s $REPO/$ARCH/APKINDEX.tar.gz | tar -Oxz |
    grep '^P:apk-tools-static$' -A1 | tail -n1 | cut -d: -f2
}

curl -s $REPO/$ARCH/apk-tools-static-$(apkv).apk |
  tar -xz -C $TMP sbin/apk.static

$TMP/sbin/apk.static --repository $REPO --update-cache --allow-untrusted \
  --root $ROOTFS --initdb add alpine-base

printf '%s\n' $REPO > $ROOTFS/etc/apk/repositories

ID=$(tar --numeric-owner -C $ROOTFS -c . | docker import - alpine:$REL)
docker tag $ID alpine:latest
docker run -i -t alpine printf 'It worked!\n'
