#!/bin/sh
mkimage -C none -A arm -T script -d boot.cmd boot/boot.scr
mkimage -C none -A arm -T script -d boot-bb2x.cmd boot/variants/bittboy2x_v1/boot.scr
mkimage -C none -A arm -T script -d boot-bb2x.cmd boot/variants/bittboy2x_v2/boot.scr
mkimage -C none -A arm -T script -d boot-bb35.cmd boot/variants/bittboy3.5/boot.scr
mkimage -C none -A arm -T script -d boot-pocketgo-v90-q90.cmd boot/variants/pocketgo_TE/boot.scr
mkimage -C none -A arm -T script -d boot-pocketgo-v90-q90.cmd boot/variants/v90_q90/boot.scr
mkimage -C none -A arm -T script -d boot-v90_v2.cmd boot/variants/v90_v2/boot.scr
mkimage -C none -A arm -T script -d boot-q20.cmd boot/variants/q20/boot.scr
mkimage -C none -A arm -T script -d boot-m3.cmd boot/variants/m3/boot.scr
mkimage -C none -A arm -T script -d boot-xyc.cmd boot/variants/xyc/boot.scr
