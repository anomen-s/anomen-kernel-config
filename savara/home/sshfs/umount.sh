#!/bin/sh

for A in mivvy tmp android raspi zax banan mtp banan malina4
do
 fusermount -z -u $A
done
