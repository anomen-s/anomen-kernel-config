#!/bin/sh

/usr/sbin/service minidlna stop

sleep 3
DLNA_DIR=/var/media

for A in filmy2  serialy2
do
   ln -sfn empty "${DLNA_DIR}/$A"
done

sed -e 's/-full.conf/-restrict.conf/' -i '/etc/default/minidlna'

/usr/sbin/service minidlna start
