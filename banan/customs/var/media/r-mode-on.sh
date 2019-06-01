#!/bin/sh

DLNA_DIR=/var/media

for A in filmy2 serialy2
do
   ln -sfn empty "${DLNA_DIR}/$A"
done
