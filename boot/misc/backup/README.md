# Some boot-related files live here, for record and convenience

## `boot.cmd`, `boot.scr`, and `gen_boot_scr.sh`

`boot.scr` is the file that u-boot reads right after hardware init and tells u-boot what to do.
It needs to reside in the root directory of the first partition on the micro SD card, FAT16 filesystem.
It is somewhat binary-ish.

`boot.cmd` is the "human-readable" version of `boot.scr`, and you can generate `boot.scr` from `boot.cmd` using the `mkimage` utility. The sources for `mkimage` come with u-boot sources, but usually one can install it system-wide (e.g. on arch linux it is in the package `uboot-tools`).

`gen_boot_scr.sh` is a convenience script that simply calls `mkimage` with the right parameters.

Regarding what can you do in `boot.cmd`, please see u-boot documentation.

## `suniv-f1c500s-miyoo.dtb`

This `dtb` file is read by u-boot and tells it some information for hardware init. (You can see it referenced in `boot.cmd`.) This is also a binary file, but it can be re-built from the kernel sources, by running `make ARCH=arm ...(stuff)... dtbs` from the same place you build a kernel. You should actually get a file which is byte-for-byte the same as the one here.

## `main`

This is a backup of the main boot script that normally resides in `rootfs/etc/main`. That one is what is called by the init process as basically the first thing after mounting partitions.

### overview of the boot process

1. CPU powers up, and runs u-boot residing from byte 8192 of the raw micro SD card.
2. U-boot reads `boot.scr` and executes the instructions (this reads the `dtb` file, does some hardware init (this is where you get the 'miyoo' splash screen), loads the kernel image (`zImage`) and runs it).
3. From now on it's a standard linux boot: The kernel initialises itself, mounts the root partition (`rootfs`) and runs `/linuxrc`. This reads `/etc/inittab`, and runs the specified commands.
4. In our setup, `inittab` mounts the partitions, and runs `/etc/main` script.
5. The `main` script does things like the boot logo and then runs gmenu2x.


## `generate_image_file.sh`

My own highly non-portable script that assembles an image.
