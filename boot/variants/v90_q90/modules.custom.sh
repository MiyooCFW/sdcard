# expected to be run from this directory
# LOGS variable is set, but it should usually be /dev/null
# CONSOLE_VARIANT is also set
#
insmod "./syscopyarea.ko"
insmod "./sysfillrect.ko"
insmod "./sysimgblt.ko"
if test -e "./flip"; then
    insmod "./r61520fb.ko" flip=1
else
    insmod "./r61520fb.ko"
fi
