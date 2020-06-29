#!/bin/sh

DLNA_DIR=/var/media
MEDIA_DIR=/mnt/WD_ELEMENTS

/usr/sbin/service minidlna stop

sleep 3

for A in filmy2 serialy2
do
   ln -sfn "${MEDIA_DIR}/${A}" "${DLNA_DIR}/${A}"
done

sed -e 's/-restrict.conf/-full.conf/' -i '/etc/default/minidlna'

/usr/sbin/service minidlna start

