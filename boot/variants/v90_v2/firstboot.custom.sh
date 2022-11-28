echo "Writing U-BOOT - DO NOT TURN OFF THE HANDHELD!!!"
dd if=../../misc/u-boot-bins/u-boot-v90_q90_pocketgo.bin of=/dev/mmcblk0 bs=1024 seek=8
