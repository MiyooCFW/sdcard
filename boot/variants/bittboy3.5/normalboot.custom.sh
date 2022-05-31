# expected to be run from this directory
# LOGS variable is set, but it should usually be /dev/null
# CONSOLE_VARIANT is also set
#
#./miyooctl setversion 3 > /dev/null 2>&1
./daemon >> "${LOGS}" 2>&1

