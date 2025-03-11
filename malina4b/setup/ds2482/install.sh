#!/bin/sh
set -e -x

mkdir -p target

for NAME in ds2482
do
 echo "File: $NAME"
 dtc -@ -O dtb -o target/custom-$NAME.dtbo -b 0 $NAME.dts

 echo "decompile: $NAME"
 dtc -O dts -o target/$NAME.decompiled.dts -I dtb target/custom-$NAME.dtbo

 sudo cp target/custom-$NAME.dtbo /boot/firmware/overlays
done

# -O output format
# -o output file
# -b boot cpu
# -@ plugin

echo Update /boot/firmware/config.txt with:
echo      dtoverlay=custom-ds2482
