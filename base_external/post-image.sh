#!/bin/bash

set -e

#BOARD_DIR="$(dirname $0)"
BOARD_DIR="../buildroot/board/raspberrypi3"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

for arg in "$@"
do
 case "${arg}" in
     # I2C
     --add-I2C)
     if ! grep -qE '^dtparam=i2c_arm=on' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
         cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"
# enable I2C
dtparam=i2c_arm=on
__EOF__
     fi
     ;;

     --gpu_mem_256=*|--gpu_mem_512=*|--gpu_mem_1024=*)
     # Set GPU memory
     gpu_mem="${arg:2}"
     sed -e "/^${gpu_mem%=*}=/s,=.*,=${gpu_mem##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
     ;;

     # Serial Port
     --add-serial)
     echo "Copying init script for serial port configuration"
     mkdir -p "${TARGET_DIR}/etc/init.d"
     cp "${BOARD_DIR}/../../../base_external/rootfs_overlay/etc/init.d/S99serial_setup" "${TARGET_DIR}/etc/init.d/"
     ;;
 esac
done

# Ensure the script is executable
chmod +x "${TARGET_DIR}/etc/init.d/S99serial_setup"

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
 --rootpath "${ROOTPATH_TMP}"   \
 --tmppath "${GENIMAGE_TMP}"    \
 --inputpath "${BINARIES_DIR}"  \
 --outputpath "${BINARIES_DIR}" \
 --config "${GENIMAGE_CFG}"

exit $?
