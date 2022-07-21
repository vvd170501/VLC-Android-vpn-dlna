#!/bin/bash
set -eu

BASEDIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

verlte() {
    [  "$1" = "`echo -e \"$1\n$2\" | sort -V | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

cd /tmp/
git clone https://code.videolan.org/videolan/vlc-android
cd ./vlc-android/
git checkout $VERSION

if verlt $VERSION 3.5.0; then
    git am --message-id "$BASEDIR/patches/pre-3.5.0/"*.patch
else
    # patch VLC's buildsystem scripts to apply other patches later
    git am --message-id "$BASEDIR/patches/buildsystem/"*.patch
    export VLC_PATCHES_DIR="$BASEDIR/patches/"
fi

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

# TODO simplify libvlc build for 3.5.0+. It should be enough to clone libvlcjni repo only
MAKEFLAGS="-j8" ./buildsystem/compile.sh -a $ARCH -r $LIBVLC_ARG
if [ $ONLY_LIBVLC = 1 ]; then
    if verlt $VERSION 3.5.0; then
        # Old file layout
        # ./vlc/build-$[build_type]/ndk/libs/${arch}/libvlc.so "$BASEDIR/out/"
        cp ./vlc/build-*/ndk/libs/*/libvlc.so "$BASEDIR/out/"
    else
        # New file layout (changed somewhere between 3.4.4 and 3.5.0)
        # ./libvlcjni/libvlc/build/intermediates/stripped_native_libs/${build_type}/out/lib/${arch}/libvlc.so
        cp ./libvlcjni/libvlc/build/intermediates/stripped_native_libs/*/out/lib/*/libvlc.so "$BASEDIR/out/"
    fi
else
    cp ./application/app/build/outputs/apk/release/VLC-Android-*.apk "$BASEDIR/out/"
fi
