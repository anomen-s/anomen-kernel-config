#!/bin/sh

#mkdir -p decompiled 

for NAME in eeprom08 dht11 ds2482 eeprom256 mcp23017
do
echo "File: $NAME"
dtc -@ -O dtb -o $NAME-overlay.dtb -b 0 $NAME.dts

#echo "decompile: $NAME"
#dtc -O dts -o decompiled/$NAME.decompiled.dts -I dtb $NAME-overlay.dtb

done

# -O output format
# -o output file
# -b boot cpu
# -@ plugin
