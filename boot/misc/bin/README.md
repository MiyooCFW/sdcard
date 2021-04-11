# some statically compiled binaries

* `busybox`, `fsck.vfat`, `mkfs.vfat`, `fatlabel` are from [static buildroot](https://github.com/bittboy/buildroot)
* `fatresize_hc` is a "minimal fat resize example" using `libparted`; the source code is [here](https://github.com/flabbergast/fatresize/tree/hardcoded); compiling requires static(musl) toolchain from the above buildroot
