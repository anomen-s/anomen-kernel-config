#/bin/sh

DEVICE=secure

sudo umount /dev/mapper/$DEVICE

sudo cryptsetup close $DEVICE
