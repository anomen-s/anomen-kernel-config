#!/bin/sh

T=`readlink -e  $0`
LUKS_DIR="${T%/mount.sh}"
LUKS_FILE="$LUKS_DIR/secure-v2.luks"
LUKS_DEVICE="secure-data-v2"
LUKS_MOUNT="$HOME/secure-data"

R=rw
if [ "x$1" = "xr" ]
then
 R=ro
fi

echo "$LUKS_FILE" "$LUKS_DEVICE" "$LUKS_MOUNT" "$R"

mkdir -p "$LUKS_MOUNT" || exit 3

sudo cryptsetup --timeout 30 open --type luks "$LUKS_FILE" "$LUKS_DEVICE" || exit 1

sudo mount -o "$R" -t ext3 "/dev/mapper/$LUKS_DEVICE" "$LUKS_MOUNT" || exit 4


exit


This is primary secure storage created on 2021-10 @ malina4 (61731745)
-passwords:
- main password (Inventory/DataManagement)
- master password

Note: secure-v2.luks.hdr.backup is header copy (first x MBs of LUKS container)

sha1
07f65da62b309c9abcf4d6042182f301e9495f4f  secure-v2.luks.hdr.backup
