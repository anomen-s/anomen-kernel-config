#!/bin/sh

pkill -9 sshfs

cd $HOME/sshfs

for A in  *
do
 if [ ! -f "$A" ]
 then
  fusermount -z -u "$A" 2>/dev/null && echo dismounted $A
 fi
done
