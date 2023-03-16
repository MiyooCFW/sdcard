#!/bin/busybox sh

touch /mnt/tvout
#killall -9 main 
sync
#for now we need reboot to reinit fb module
reboot  
