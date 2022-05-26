# expected to be run from this directory
# LOGS variable is set, but it should usually be /dev/null
# CONSOLE_VARIANT is also set
#
insmod "./syscopyarea.ko"
insmod "./sysfillrect.ko"
insmod "./sysimgblt.ko"
#insmod "./r61520fb.ko" version=1 flip=1 invert=1
insmod "./r61520fb.ko" version=1 flip=1 invert=0
