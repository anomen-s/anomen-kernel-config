#!/bin/sh

DLNA_DIR=/var/media

if [ "--check" "=" "$1" ]
then
 ls -ld /var/media/filmy2 | grep -q /mnt/ext || exit 0
fi

/usr/sbin/service minidlna stop

sleep 3

for A in filmy2 serialy2 audio2
do
   ln -sfn empty "${DLNA_DIR}/$A"
done

ln -s -f -n minidlna-restrict.conf /etc/minidlna.conf

/usr/sbin/service minidlna start
