#!/bin/sh

sudo umount /dev/mapper/secure-data-v2

sudo cryptsetup close secure-data-v2

ls -la /dev/mapper
