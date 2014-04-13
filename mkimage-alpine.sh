#!/bin/sh

[ $(id -u) -eq 0 ] || {
  printf >&2 '%s requires root\n' "$0"
  exit 1
}

usage() {
  printf >&2 '%s: [-r release] [-m mirror]\n' "$0"
  exit 1
}

tmp() {
  TMP=$(mktemp -d /tmp/alpine-docker-XXXXXXXXXX)
  ROOTFS=$(mktemp -d /tmp/alpine-docker-rootfs-XXXXXXXXXX)
  trap "rm -rf $TMP $ROOTFS" EXIT TERM INT
}

apkv() {
  curl -s $REPO/$ARCH/APKINDEX.tar.gz | tar -Oxz |
    grep '^P:apk-tools-static$' -A1 | tail -n1 | cut -d: -f2
}

getapk() {
  curl -s $REPO/$ARCH/apk-tools-static-$(apkv).apk |
    tar -xz -C $TMP sbin/apk.static
}

mkbase() {
  $TMP/sbin/apk.static --repository $REPO --update-cache --allow-untrusted \
    --root $ROOTFS --initdb add alpine-base
}

conf() {
  printf '%s\n' $REPO > $ROOTFS/etc/apk/repositories
}

pack() {
  ID=$(tar --numeric-owner -C $ROOTFS -c . | docker import - alpine:$REL)
  docker tag $ID alpine:latest
  docker run -i -t alpine printf 'alpine:%s with id=%s created!\n' $REL $ID
}

while getopts "hr:m:" opt; do
  case $opt in
    r)
      REL=$OPTARG
      ;;
    m)
      MIRROR=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

REL=${REL:-edge}
MIRROR=${MIRROR:-http://nl.alpinelinux.org/alpine}
REPO=$MIRROR/$REL/main
ARCH=$(uname -m)

tmp && getapk && mkbase && conf && pack
