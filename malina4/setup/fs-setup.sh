#!/bin/sh

mkdir -p /mnt/ext /mnt/ext2 /mnt/work /mnt/usb

for D in download oss repos tmp
do
 mkdir -p "/mnt/work/$D"
done