#!/bin/busybox sh

if (grep -q mmcblk0p1 "/sys/devices/platform/soc/1c13000.usb/musb-hdrc.1.auto/gadget/lun0/file"); then
echo /dev/mmcblk0p4 >  /sys/devices/platform/soc/1c13000.usb/musb-hdrc.1.auto/gadget/lun0/file
elif (grep -q mmcblk0p4 "/sys/devices/platform/soc/1c13000.usb/musb-hdrc.1.auto/gadget/lun0/file"); then
echo /dev/mmcblk0p1 >  /sys/devices/platform/soc/1c13000.usb/musb-hdrc.1.auto/gadget/lun0/file
else
sleep 2
echo "No FAT partition available!"
fi
