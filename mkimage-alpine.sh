#!/bin/sh

REL=${REL:-edge}
ARCH=${ARCH:-x86_64}
MIRROR=${MIRROR:-http://nl.alpinelinux.org/alpine}
REPO=$MIRROR/$REL/main/$ARCH

TMP=$(mktemp -d /tmp/alpine-docker-XXXXXXXXXX)
trap "rm -r $TMP" EXIT TERM INT

apkv() {
  curl -s $REPO/APKINDEX.tar.gz | tar -Oxz | grep '^P:apk-tools-static$' -A1 |
    tail -n1 | cut -d: -f2
}
