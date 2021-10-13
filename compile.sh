#!/bin/bash
set -eu

BASEDIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd /tmp/
git clone https://code.videolan.org/videolan/vlc-android
cd ./vlc-android/
git checkout $VERSION
git am --message-id "$BASEDIR"/patches/*.patch

LIBVLC_ARG=""
ONLY_LIBVLC=0
while [ $# -gt 0 ]; do
    case $1 in
        -l|--only-libvlc)
            LIBVLC_ARG="-l"
            ONLY_LIBVLC=1
            ;;
    esac
    shift
done

MAKEFLAGS="-j8" ./buildsystem/compile.sh -a $ARCH -r $LIBVLC_ARG
if [ $ONLY_LIBVLC = 1 ]; then
    cp ./vlc/build-*/ndk/libs/*/libvlc.so "$BASEDIR/out/"
else
    cp ./application/app/build/outputs/apk/release/VLC-Android-*.apk "$BASEDIR/out/"
fi
