#!/bin/sh

# kernell install script

# $Id$ 

# System settings:
#ROOT=`cat /etc/fstab | sed -ne 's@^[ \t]*\([^ \t][^ \t]*\)[ \t][ \t]*/[ \t].*@\1@p'`
ROOT=/dev/sda4

echo chown portage...
chown portage . -R

echo make prepare
make prepare

# extract verions
#KERNEL=`make kernelversion`
KERVER=`make kernelrelease`

echo "Root: $ROOT"
#echo "Kern: $KERNEL"
#echo "KVer: $KERVER"

echo -n Build '&' install kernel "$KERVER" ' ?'
read 

#echo Building kernel
echo make clean...
make clean

echo make prepare...
make prepare

echo make all...
su portage -c make all

echo make modules_install...
make modules_install || exit 10

cp -v ./arch/x86/boot/bzImage "/boot/kernel-$KERVER" || exit 1
cp -v ./System.map "/boot/System.map-$KERVER" || exit 2
cp -v ./.config "/boot/Config-$KERVER" || exit 3


echo "" >> /boot/grub/grub.conf
echo "title=Linux $KERVER" >> /boot/grub/grub.conf
echo "kernel" "/boot/kernel-$KERVER" "root=$ROOT" "ro" >> /boot/grub/grub.conf

echo "* INFO *"
echo grub.conf was updated, but manual check is recomended.
echo ""
echo Finished.
