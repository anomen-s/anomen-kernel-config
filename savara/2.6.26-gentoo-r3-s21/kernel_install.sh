#!/bin/sh

# System settings:
ROOT=`cat /etc/fstab | sed -ne 's@^[ \t]*\([^ \t][^ \t]*\)[ \t][ \t]*/[ \t].*@\1@p'`
grep -q 'CONFIG_X86_32=y' .config && ARCH=i386
grep -q 'CONFIG_X86_64=y' .config && ARCH=x86_64

#ROOT=/dev/hda2

make prepare

# extract verions
#KERNEL=`make kernelversion`
KERVER=`make kernelrelease`

echo "Arch: $ARCH"
echo "Root: $ROOT"
#echo "Kern: $KERNEL"
echo "KVer: $KERVER"

echo -n Build '&' install kernel "$KERVER" ' ?'
read 

#echo Building kernel
echo make clean...
make clean


echo make all...

chown portage . -R
su portage -c make all

make modules_install || exit 10

cp -v ./arch/$ARCH/boot/bzImage "/boot/kernel-$KERVER" || exit 1
cp -v ./System.map "/boot/System.map-$KERVER" || exit 2
cp -v ./.config "/boot/Config-$KERVER" || exit 3


echo "" >> /boot/grub/grub.conf
echo "title=Linux $KERVER" >> /boot/grub/grub.conf
echo "kernel" "/boot/kernel-$KERVER" "root=$ROOT" "ro" >> /boot/grub/grub.conf

echo "* INFO *"
echo grub.conf was updated, but manual check is recomended.
echo ""
echo Finished.
