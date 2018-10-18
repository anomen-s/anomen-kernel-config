#!/bin/sh

# kernell install script

# $Id$ 

# System settings:
ROOT=/dev/sda1

echo chown `whoami`
sudo chown `whoami` -R .

echo make prepare
make prepare || exit 5

# extract verions
KERVER=`make kernelrelease`

echo "Root: $ROOT"

echo -n Building kernel "$KERVER" ...
sleep 3

echo make clean...
make clean || exit 6

echo make prepare...
make prepare || exit 7

echo make all...
make all || exit 8

echo -n Install kernel "$KERVER" ' ?'
read 

echo make modules_install...
sudo make modules_install || exit 10

#echo mount /boot with rw
#mount /boot -o remount,rw


sudo cp -v ./arch/x86/boot/bzImage "/boot/kernel-$KERVER" || exit 1
sudo cp -v ./System.map "/boot/System.map-$KERVER" || exit 2
sudo cp -v ./.config "/boot/Config-$KERVER" || exit 3
sudo cp -v ./Module.symvers "/boot/Module.symvers-$KERVER" || exit 3


echo "GRUB2 not updated"
echo ""
echo Finished.

