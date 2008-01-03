#!/bin/sh

# System settings:
ROOT=/dev/hda2
ARCH=i386 #x86_64

# extract verions
KERNEL=`pwd | sed -e 's@.*/linux-@@'`
KERBUILD=`sed -ne 's/CONFIG_LOCALVERSION="\(.*\)"/\1/p' .config`
KERVER="$KERNEL$KERBUILD"

echo -n install kernel "$KERVER" ' ?'
read 

cp -v ./arch/$ARCH/boot/bzImage "/boot/kernel-$KERVER" || exit 1
cp -v ./System.map "/boot/System.map-$KERVER" || exit 2
cp -v ./.config "/boot/Config-$KERVER" || exit 3


echo "" >> /boot/grub/grub.conf
echo "title=Linux $KERVER" >> /boot/grub/grub.conf
echo kernel "/boot/kernel-$KERVER" "root=$ROOT" >> /boot/grub/grub.conf
