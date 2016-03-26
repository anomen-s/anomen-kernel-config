#!/bin/sh

H=172.17.2.60

if [ -n "$1" ]
then
  H=$1
fi

sshfs -o nonempty  -o transform_symlinks  root@$H:/ $HOME/sshfs/android
