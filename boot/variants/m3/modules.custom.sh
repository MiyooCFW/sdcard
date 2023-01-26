# expected to be run from this directory
# LOGS variable is set, but it should usually be /dev/null
# CONSOLE_VARIANT is also set
#
video=`cat ../../uEnv.txt |grep -a "CONSOLE_VIDEO" | cut -d "=" -f 2`
insmod "../../$video" version=1 invert=1 flip=1 debug=1 lowcurrent=1