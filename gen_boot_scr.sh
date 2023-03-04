#!/bin/sh
mkimage -C none -A arm -T script -d boot.cmd boot/boot.scr
mkimage -C none -A arm -T script -d boot-1bit.cmd boot/boot-1bit.scr
mkimage -C none -A arm -T script -d boot-test.cmd boot/boot-test.scr
# bootcmd_args in boot.cmd are variables set automatic by u-boot at launch
# you can pass your own values and generate custom boot.scr (see example in boot-test.cmd)
