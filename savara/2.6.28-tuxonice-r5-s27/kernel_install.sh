#!/bin/sh

# kernell install script

# $Id$ 

# System settings:
ROOT=/dev/sda2

echo chown portage...
chown portage . -R || exit 4

echo make prepare
make prepare || exit 5

# extract verions
KERVER=`make kernelrelease`

echo "Root: $ROOT"

echo -n Build '&' install kernel "$KERVER" ' ?'
read 

echo make clean...
make clean || exit 6

echo make all...
su portage -c make all || exit 7

echo make modules_install...
make modules_install || exit 10

cp -v ./arch/x86/boot/bzImage "/boot/kernel-$KERVER" || exit 1
cp -v ./System.map "/boot/System.map-$KERVER" || exit 2
cp -v ./.config "/boot/Config-$KERVER" || exit 3


echo "" >> /boot/grub/grub.conf
echo "# #" >> /boot/grub/grub.conf
echo "title=Linux $KERVER" >> /boot/grub/grub.conf
echo "kernel" "/boot/kernel-$KERVER" "root=$ROOT" "ro" >> /boot/grub/grub.conf

echo "* INFO *"
echo grub.conf was updated, but manual check is recomended.
echo ""
echo Finished.
