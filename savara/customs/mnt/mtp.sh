#!/bin/sh
simple-mtpfs -l
sudo mkdir -p /mnt/mtp
sudo simple-mtpfs -o allow_other -v /mnt/mtp

