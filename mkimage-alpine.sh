#!/bin/sh

REL=${REL:-edge}
ARCH=${ARCH:-x86_64}
MIRROR=${MIRROR:-http://nl.alpinelinux.org/alpine}
REPO=$MIRROR/$REL/main/$ARCH

TMP=$(mktemp -d /tmp/alpine-docker-XXXXXXXXXX)
trap "rm -r $TMP" EXIT TERM INT
