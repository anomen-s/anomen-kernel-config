#!/bin/sh

DLNA_DIR=/var/media
MEDIA_DIR=/mnt/WD_ELEMENTS

for A in filmy2 serialy2
do
   ln -sfn "${MEDIA_DIR}/${A}" "${DLNA_DIR}/${A}"
done
