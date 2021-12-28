#/bin/sh

sudo umount /dev/mapper/secure

sudo cryptsetup close secure
