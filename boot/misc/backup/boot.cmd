setenv bootargs console=tty0 console=ttyS1,115200 panic=5 rootwait root=/dev/mmcblk0p2 rw
fatload mmc 0:1 0x80008000 console.cfg
env import -t 0x80008000 ${filesize}
load mmc 0:1 0x80C00000 suniv-f1c500s-miyoo.dtb
load mmc 0:1 0x80008000 variants/${CONSOLE_VARIANT}/zImage
bootz 0x80008000 - 0x80C00000
