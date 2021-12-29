#! /bin/sh

# disable USB and LAN wakup
echo XHC | sudo tee /proc/acpi/wakeup
echo GLAN | sudo tee /proc/acpi/wakeup

#if ! grep -q /dev/sda3 /proc/swaps  ; then sudo swapon /dev/sda3 ; fi


dmesg -c > /var/log/dmesg.hib.log

# free caches
# once was needed to avoid bug(?)  when hibernating into small swap
ZEROFILE=/dev/shm/zerofile.tmp
dd if=/dev/zero of=$ZEROFILE bs=1M count=8190
rm $ZEROFILE

sync

sleep 1

echo $0
date
# hibernate using:
# /usr/sbin/hibernate --force 


