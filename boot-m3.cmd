setenv bootargs console=tty0 console=ttyS1,115200 panic=5 rootwait root=/dev/mmcblk0p2 rw miyoo_kbd.miyoo_ver=3 miyoo_kbd.miyoo_layout=1 miyoo.miyoo_snd=2
fatload mmc 0:1 0x80008000 console.cfg
env import -t 0x80008000 ${filesize}
load mmc 0:1 0x80C00000 suniv-f1c500s-miyoo-1bit.dtb
load mmc 0:1 0x80008000 zImage
bootz 0x80008000 - 0x80C00000
