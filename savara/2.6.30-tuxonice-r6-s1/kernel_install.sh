#!/bin/sh

# kernell install script

# $Id$ 

# System settings:
ROOT=/dev/sda2

echo make prepare
make prepare || exit 5

# extract verions
KERVER=`make kernelrelease`

echo "Root: $ROOT"

echo -n Build '&' install kernel "$KERVER" ' ?'
read 

echo chown portage...
chown portage . -R || exit 4

echo make clean...
su portage -c "make clean" || exit 6

echo make prepare...
su portage -c "make prepare" || exit 7

echo make all...
su portage -c "make all" || exit 8

echo make modules_install...
make modules_install || exit 10

echo mount /boot with rw
mount /boot -o remount,rw

cp -v ./arch/x86/boot/bzImage "/boot/kernel-$KERVER" || exit 1
cp -v ./System.map "/boot/System.map-$KERVER" || exit 2
cp -v ./.config "/boot/Config-$KERVER" || exit 3


echo "" >> /boot/grub/grub.conf
echo "# ? & ?" >> /boot/grub/grub.conf
echo "title=Linux $KERVER" >> /boot/grub/grub.conf
echo "kernel" "/boot/kernel-$KERVER" "root=$ROOT" "ro" >> /boot/grub/grub.conf
echo "title=Linux $KERVER noresume" >> /boot/grub/grub.conf
echo "kernel" "/boot/kernel-$KERVER" "root=$ROOT" "ro" "noresume" "nox" >> /boot/grub/grub.conf 

echo "* INFO *"
echo grub.conf was updated, but manual check is recomended.
echo ""
echo Finished.
