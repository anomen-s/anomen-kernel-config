#!/bin/sh

cd /tmp/bc

wget https://bitcoin.org/bin/bitcoin-core-22.0/bitcoin-22.0-arm-linux-gnueabihf.tar.gz

tar xvf *.tar.gz

sudo cp -avr bitcoin-22.0  /opt

sudo mkdir -p /mnt/work/bitcoin/$USER

ln -sfn /mnt/work/bitcoin/$USER ~/.bitcoin
