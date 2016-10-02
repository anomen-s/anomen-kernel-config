#!/bin/sh

#make prepare


# extract verions
KERVER=`make kernelrelease`

echo -n Build '&' install kernel "$KERVER" ' ?'
read TMP

#make all
#sudo make modules_install
#sudo make firmware_install

sudo mount -o remount,rw /boot

sudo cp -v ./arch/arm/boot/zImage "/boot/kernel-$KERVER.img" || exit 1
sudo cp -v ./System.map "/lib/modules/System.map-$KERVER" || exit 2
sudo cp -v ./.config "/lib/modules/Config-$KERVER" || exit 3
sudo cp -v ./Module.symvers "/lib/modules/Module.symvers-$KERVER" || exit 3

sudo sed -i -e "s/^kernel=.*/kernel=kernel-$KERVER.img/" /boot/config.txt
