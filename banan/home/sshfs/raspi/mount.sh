#!/bin/sh

H=raspi

if [ -n "$1" ]
then
  H=$1
fi

sshfs -o nonempty  -o transform_symlinks $H:/ $HOME/sshfs/raspi
