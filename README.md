# miyooimg

Repository with some binaries and scripts to assemble a Custom FirmWare image for "Miyoo" devices (Bittboys, Pocket Go V1, Powkiddy V90 and Q90).

TL;DR: to generate a minimal image, run `./generate_image_file.sh` on a linux system (some standard packages are required on the host; `x86_64` only).

The output will be a `cfw-dev-<DATE>.img` file which can be written onto a micro sd card.

By default, it is aimed at Powkiddy V90 or Q90. You can change which handheld it should be running on by editing `boot/console.cfg` (or `console.cfg` on the `BOOT` partition) and changing the value of the variable there to the name of one of the subdirectories in `boot/variants` (case matters).

When booted for the _first time_, the boot splash logo may be upside-down or even not appearing at all; in any case please wait about 30 seconds (maybe more if your sd card is big) or until you see the screen turn off,  and then turn the handheld off. The subsequent boots should be "normal".

## Description of various parts of what is here

There are essentially four "ingredients" that go into the image: __u-boot__ (the bootloader), __the kernel__ plus modules and support programs, __root filesystem__, and __apps/emulators/ports,...__

All of these can (in principle) be compiled from source. This repo has _only_ binary images, not sources.

### U-Boot

The main repository for the source code is [here][uboot]. Currently (2021-04-06) does not quite compile into a binary that you can directly use here... WIP.

The u-boot binaries differ from handheld to handheld (because they all initalise the screen, which is different); the binaries are here in `boot/misc/u-boot-bins`.

This is the code that runs the first thing after boot, and is responsible for the "Miyoo CFW" splash image. It reads `boot.scr` file from the first partition on the micro SD card and executes instructions in it. For reproducing this file from source, have a look at the README in `boot/misc/backup`.

Currently this file reads `console.cfg`, loads the correct kernel from `variants/$CONSOLE_VARIANT` and hands over to it.

### linux kernel

In the current arrangements, all the kernel-related files are in `boot/variants/$CONSOLE_VARIANT` subdirectories; these (can) also differ between the handheld variants. The main ones are `zImage` (which is the main "kernel") and then some drivers named `*.ko`. Any special module loading logic on boot can be in `modules.custom.sh` script.

There are two more userspace programs that talk to the kernel & modules, namely [daemon][daemon] and [miyooctl][miyooctl]. These are called/loaded from `normalboot.custom.sh` script.
`miyooctl` lets the drivers know which "version" of hardware should they expect; `daemon` monitors for some keypad shortcuts. These can be cross-compiled from the sources linked above, using the proper toolchain.

The custom 4.14.0 linux kernel sources are in [this repository][kernel]. In the current form (2021-04-06) they compile into a kernel that works at least on Bittboy v3.5 and Powkiddy V90; this is the one supplied in `boot/variants/{v90_q90,bittboy3.5}`. All the other variants supplied here contain the kernel and modules taken from CFW 1.3.3 release.


### root filesystem

This is what becomes the `/` directory when linux runs. This can be in principle compiled from [these sources][buildroot], but at the moment (2021-04-06) the buildroot configuration does not match the archived binary supplied here (as `rootfs.tar.xz`) which is essentially the root filesystem used on CFW 1.3.3. (I.e. if you compile rootfs from the buildroot and replace the one here, many apps/emus will stop working; this is musl-vs-uclibc issue.).

The really custom bits in `rootfs.tar.xz` that need carrying over if you compile your own are `etc/inittab`, `etc/main` and having `/boot` and `/mnt` directories.

However one very useful thing that _can_ be squeezed from the current buildroot is a _toolchain_. Just run `make sdk` in the buildroot.

### main partition

These are apps/emulators/ports/games that run on the device. The required one being [gmenu2x][gmenunx]. Here supplied in the `main` directory. All binaries, taken directly from CFW 1.3.3 release.

For recompiling you need to track down their source yourself (other than [gmenu2x][gmenunx]).

There are a couple of free homebrew roms included here, to be able to test the image. Please see the credits below!





# Included games/ROMs links/credits

## NES

- [Alter Ego](https://www.romhacking.net/homebrew/1/)
- [From Below](https://mhughson.itch.io/from-below)

## GB

- [Dangan](https://snorpung.itch.io/dangan-gb)
- [The bouncing ball](http://gb.cabbage.cx/)

## GBC

- [ucity](https://github.com/AntonioND/ucity)
- [vectroid](https://gitlab.com/BonsaiDen/vectroid.gb)

## games

- [CircuitDude](http://www.circuitdude.com/)
- [Hocoslamfy](https://github.com/Nebuleon/hocoslamfy)




[uboot]: https://github.com/MiyooCFW/uboot
[daemon]: https://github.com/MiyooCFW/daemon
[miyooctl]: https://github.com/MiyooCFW/miyooctl
[buildroot]: https://github.com/MiyooCFW/buildroot
[gmenunx]: https://github.com/MiyooCFW/gmenunx
[kernel]: https://github.com/MiyooCFW/kernel
