#!/bin/sh -x

mkdir -p $HOME/secure-data/local

sudo cryptsetup --timeout 30 open --type luks $HOME/secure-data/secure.luks secure || exit 1

sudo mount /dev/mapper/secure  $HOME/secure-data/local

