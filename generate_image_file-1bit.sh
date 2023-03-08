#!/usr/bin/env bash
set -euo pipefail


# Determine the version if it's not set
# If we're on a tagged commit, then this is just the tag
# Otherwise it's the last tag, then the number of commits since that tag, then the current hash
# Finally, if there are uncommitted changes, -dirty is appended
# If there are no git tags, fall back to just the short hash
VERSION="${VERSION:-$(git describe --tags --dirty || git rev-parse --short HEAD)}"

ROOTDIR="."
UBOOTBIN="${ROOTDIR}/boot/misc/u-boot-bins/u-boot-sunxi-with-spl-1bit.bin"
OUTFILE="${ROOTDIR}/cfw-${VERSION}.img"

## helpers
BOLDRED='\e[1;31m'
BOLDCYAN='\e[1;36m'
NORMCYAN='\e[1;36m'
RESET='\e[0m'
MSGCOLOR="${BOLDCYAN}"
WARNCOLOR="${BOLDRED}"
INFOCOLOR="${NORMCYAN}"
function msg() {
    echo -e "${MSGCOLOR}$0: "$@"${RESET}"
}
function info () {
    echo -e "${INFOCOLOR}$0: "$@"${RESET}"
}
## end_helpers

BB="${ROOTDIR}/tools/busybox"

if test "$EUID" -ne 0; then
  msg "Please run as root."
  exit 1
fi

for prg in sfdisk mkdosfs mkfs.ext4; do
    if test -d $(${BB} which $prg 2> /dev/null); then
        msg "This script requires '${WARNCOLOR}$prg${MSGCOLOR}' program. Please get/install it and run again."
        exit 1
    fi
done

BOOTFILES="${ROOTDIR}/boot"
ETCFILES="${ROOTDIR}/etc"
MAINFILES="${ROOTDIR}/main"
ROOTFILES="${ROOTDIR}/rootfs.tar.xz"

msg "Creating image file ..."
dd if=/dev/zero of="${OUTFILE}" bs=1024 count=1179648

msg "Mapping image as a loop device ..."
LOOPDEV=$(${BB} losetup -f)
$BB losetup "${LOOPDEV}" "${OUTFILE}"

msg "Creating partition table ..."
sfdisk "${LOOPDEV}" << EOF
,261120,b
,261120,L
,522240,S
,,b;
EOF

# OK, so it should be enough to call partprobe, but it is inexplicably failing on my machine
# so just re-map the loop device
msg "Remapping the loop device ..."
$BB losetup -d "${LOOPDEV}"
$BB losetup -P "${LOOPDEV}" "${OUTFILE}"

msg "Writing u-boot ..."
$BB dd if="${UBOOTBIN}" of="${LOOPDEV}" bs=1024 seek=8

msg "Formatting partitions ..."
mkdosfs -F 32 -s 2 -n BOOT "${LOOPDEV}p1"
mkfs.ext4 -L rootfs "${LOOPDEV}p2"
mkdosfs -F 32 -n MAIN "${LOOPDEV}p4"
$BB mkswap "${LOOPDEV}p3"

# temporary mount point
TEMPMOUNT=$(${BB} mktemp -d)

# copy over
info "If some the following fails, you may need to '${WARNCOLOR}umount ${TEMPMOUNT}${INFOCOLOR}', '${WARNCOLOR}rmdir ${TEMPMOUNT}${INFOCOLOR}' and '${WARNCOLOR}losetup -d ${LOOPDEV}${INFOCOLOR}' to clean up."
msg "Unpacking rootfs ..."
$BB mount "${LOOPDEV}p2" "${TEMPMOUNT}"
$BB tar x -C "${TEMPMOUNT}" -J -f "${ROOTFILES}"
msg "Copying over etc files ..."
$BB cp -Lr "${ETCFILES}"/* "${TEMPMOUNT}/etc/"
$BB umount "${TEMPMOUNT}"
msg "Copying over boot files ..."
$BB mount "${LOOPDEV}p1" "${TEMPMOUNT}"
$BB cp -Lr "${BOOTFILES}"/* "${TEMPMOUNT}"
$BB cp -Lr "${BOOTFILES}"/boot-1bit.scr "${TEMPMOUNT}/boot.scr"
msg "Writing $VERSION to /boot/version.txt..."
echo "$VERSION" > "${TEMPMOUNT}/version.txt"
$BB umount "${TEMPMOUNT}"
msg "Copying over main files ..."
$BB mount "${LOOPDEV}p4" "${TEMPMOUNT}"
$BB cp -Lr "${MAINFILES}"/. "${TEMPMOUNT}"
$BB umount "${TEMPMOUNT}"

# remove temp dir
test -d "${TEMPMOUNT}" && rmdir "${TEMPMOUNT}"
info "Cleaned up mounts and tempdir."

# shall we keep loop mapped?
PARAM=${1:-}
if test "$PARAM" == "keep"; then
    msg "Image file still mapped on ${LOOPDEV}; use '${WARNCOLOR}losetup -d ${LOOPDEV}${MSGCOLOR}' when finished."
else
    $BB losetup -d "${LOOPDEV}"
fi

msg "Finished: ${OUTFILE} is ready."
