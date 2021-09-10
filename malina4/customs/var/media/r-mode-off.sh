#!/bin/sh

DLNA_DIR=/var/media
MEDIA_DIR=/mnt/ext


if [ "--check" "=" "$1" ]
then
 ls -ld /var/media/filmy2 | grep -q /mnt/ext && exit 0
fi

/usr/sbin/service minidlna stop

sleep 3

for A in filmy2 serialy2 audio2
do
   ln -sfn "${MEDIA_DIR}/${A}" "${DLNA_DIR}/${A}"
done

ln -s -f -n minidlna-full.conf /etc/minidlna.conf

/usr/sbin/service minidlna start

