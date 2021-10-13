#!/bin/bash

set -eu

BASEDIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MPOINT=/tmp/res/

mkdir -p "$BASEDIR/out"
chmod a+w "$BASEDIR/out"
docker run \
    -it --rm \
    -v "$BASEDIR:$MPOINT" \
    -e ARCH=${ARCH:-arm64} -e VERSION=${VERSION:-3.4.1} \
    registry.videolan.org/vlc-debian-android:20210915065913 "$MPOINT/compile.sh" "$@"