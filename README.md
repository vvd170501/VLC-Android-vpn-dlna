This repository contains patches for [VLC for Android](https://code.videolan.org/videolan/vlc-android) which enable discovery of UPNP/DLNA servers over VPN.

These patches were tested on arm64 with some recent versions of VLC app (see below). They may not work with other versions or architectures.

## Usage:

### Manual patching

1) Clone the [official repository](https://code.videolan.org/videolan/vlc-android), checkout a compatible version
2) Apply [the first patch](0001-allow-tunnel-miface.patch)
3) Build the application (with libvlc) OR build a compatible version of libvlc and replace the `libvlc.so` in the original APK (e.g. using Apktool)
4) Add `--miface=tun0` (real interface name may be different) in `Advanced settings` -> `custom libVLC options`
5) Restart the application

To use another interface (e.g. a wireless adapter) for DLNA discovery, remove the `--miface` option and restart the app

### Automatic interface selection:
You may apply [the second patch](0002-auto-interface.patch) after step 2.
With this patch applied, libupnp will use the default interface which is used to send packets to `239.255.255.250` (i.e. `$(ip route get 239.255.255.250)`).
You should still be able to overwrite the interface for libupnp via the `--miface` option

### Build with Docker (applies both patches)

```bash
# build the APK (unsigned release version)
./build.sh
# build only libvlc
./build.sh -l
```

You can use `ARCH` (default is `arm64`) and `VERSION` (default `3.5.0`) environment variables to select a different architecture or VLC version.
Use `DOCKER_IMAGE_TAG` environment variable to select which version of `registry.videolan.org/vlc-debian-android` image will be used for build.

Generated files are saved to `./out`.

### Tested builds

```bash
# NOTE doesn't work anymore (git clone fails due to certificate error). May still be possible to build with a newer docker image
DOCKER_IMAGE_TAG=20200529135226 VERSION=3.3.4 ./build.sh -l

DOCKER_IMAGE_TAG=20210915065913 VERSION=3.4.1 ./build.sh -l
DOCKER_IMAGE_TAG=20210915065913 VERSION=3.4.4 ./build.sh -l

DOCKER_IMAGE_TAG=20220224093321 VERSION=3.5.0 ./build.sh -l
```
