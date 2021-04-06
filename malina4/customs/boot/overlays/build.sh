#!/bin/sh

mkdir -p decompiled

for NAME in ds2482
do
echo "File: $NAME"
dtc -@ -O dtb -o $NAME.dtbo -b 0 $NAME.dts

echo "decompile: $NAME"
dtc -O dts -o decompiled/$NAME.decompiled.dts -I dtb $NAME.dtbo

done

# -O output format
# -o output file
# -b boot cpu
# -@ plugin
