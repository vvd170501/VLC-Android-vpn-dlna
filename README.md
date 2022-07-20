This repository contains patches for [VLC for Android](https://code.videolan.org/videolan/vlc-android) which enable discovery of UPNP/DLNA servers over VPN.

Patches were tested on arm64 with the following VLC versions:
- [3.3.4](https://code.videolan.org/videolan/vlc-android/-/commit/13e15aa9d2c691a7fdfbf4ab91df9a7299d590bf),
- [3.4.1](https://code.videolan.org/videolan/vlc-android/-/commit/d80f98933c30b561d3b00f1c61ecf6b59fcbb18e),
- [3.4.4](https://code.videolan.org/videolan/vlc-android/-/commit/fbedb374271a0e38a7971647bfe9d4d753f48fdb)
- [3.5.0](https://code.videolan.org/videolan/vlc-android/-/commit/5855fc645a177d7870b56f6f9b7768353798e7e3)
These patches may not work with other versions or different architectures.

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

Generated files are saved to `./out`.
