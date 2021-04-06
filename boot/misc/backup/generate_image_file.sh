#!/bin/bash

# !!! no error checking in done, so CAREFUL or the script will EAT YOUR HAMSTER !!!

# !!! also NOT PORTABLE, depends on several things that i have installed !!!

DOAS=doas
#DOAS=sudo

MIYOOROOT="$(pwd)/../../.."
FILE="${MIYOOROOT}/cfw-dev-$(date '+%Y%m%d').img"
ROOTFS="${MIYOOROOT}/rootfs.fsa"
MIYOOBOOT="${MIYOOROOT}/miyooboot"
MIYOOMAIN="${MIYOOROOT}/moving-over"
UBOOTBIN="${MIYOOROOT}/miyooboot/misc/u-boot-bins/u-boot-v90_q90_pocketgo.bin"
TEMPMOUNT="/mnt/temp"

dd if=/dev/zero of=$FILE bs=1024 count=1048576

LOOPDEV=$(udisksctl loop-setup --file $FILE | sed 's|.*/dev/loop\([0-9]\)\.|/dev/loop\1|')

sfdisk $LOOPDEV << EOF
,522240,6
,522240,L
,522240,S
,,b;
EOF

sleep 1

# write u-boot
dd if="${UBOOTBIN}" of="${LOOPDEV}" bs=1024 seek=8

# format fat partitions and swap
$DOAS mkdosfs -F 16 -n BOOT "${LOOPDEV}p1"
$DOAS mkdosfs -F 32 -n MAIN "${LOOPDEV}p4"
$DOAS mkswap "${LOOPDEV}p3"

# write the rootfs
[ -r "$ROOTFS" ] && $DOAS fsarchiver restfs "$ROOTFS" id=0,dest="${LOOPDEV}p2"

# copy over fat stuff
echo "Copying files..."
$DOAS mount "${LOOPDEV}p1" "${TEMPMOUNT}"
$DOAS cp -Lr "${MIYOOBOOT}"/* "${TEMPMOUNT}"
$DOAS umount "${TEMPMOUNT}"
$DOAS mount "${LOOPDEV}p4" "${TEMPMOUNT}"
$DOAS cp -Lr "${MIYOOMAIN}"/* "${TEMPMOUNT}"
$DOAS umount "${TEMPMOUNT}"

if [ "$1" == "keep" ]; then
    echo "Image file still mapped on $LOOPDEV; use 'udisksctl loop-delete -b $LOOPDEV' when finished."
else
    udisksctl loop-delete -b $LOOPDEV
fi

