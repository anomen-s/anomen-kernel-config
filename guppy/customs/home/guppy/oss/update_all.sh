#!/bin/sh

for A in kernel-config anomen-overlay
do
 cd $HOME/oss/$A
 git pull
done

