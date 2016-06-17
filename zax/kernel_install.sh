#!/bin/sh

# kernell install script

# $Id$ 

# System settings:
ROOT=/dev/sda1
U=kernelbuilder

if ! grep "$U:x:" /etc/passwd -q
then
 echo "User $U needed for building needed, create it using:"
 echo "   useradd -m $U"
 exit 4
fi

echo chown "$U"
chown "$U" -R .

echo make prepare
su $U -c  'make prepare' || exit 5

# extract verions
KERVER=`su $U -c  'make kernelrelease'`

echo "Root: $ROOT"

echo -n Building kernel "$KERVER"
read

echo make clean...
su $U -c  'make clean' || exit 6

echo make prepare...
su $U -c  'make prepare' || exit 7

echo make all...
su $U -c  'make all' || exit 8

echo -n Install kernel "$KERVER" ' ?'
read 

echo make modules_install...
make modules_install || exit 10

echo make firmware_install...
make firmware_install || exit 11

#echo mount /boot with rw
#mount /boot -o remount,rw


cp -v ./arch/x86/boot/bzImage "/boot/kernel-$KERVER" || exit 1
cp -v ./System.map "/boot/System.map-$KERVER" || exit 2
cp -v ./.config "/boot/Config-$KERVER" || exit 3
cp -v ./Module.symvers "/boot/Module.symvers-$KERVER" || exit 3

cp /boot/grub/grub.conf `mktemp -t grub.conf-XXXXXX`

echo "" >> /boot/grub/grub.conf
echo "# ? & ?" >> /boot/grub/grub.conf
echo "title=Linux $KERVER" >> /boot/grub/grub.conf
echo "kernel" "/boot/kernel-$KERVER" "root=$ROOT" "ro" >> /boot/grub/grub.conf
echo "title=Linux $KERVER failsafe" >> /boot/grub/grub.conf
echo "kernel" "/boot/kernel-$KERVER" "root=$ROOT" "ro" "noresume" "nox" >> /boot/grub/grub.conf

echo "* INFO *"
echo grub.conf was updated, but manual check is recomended.
echo ""
echo Finished.

