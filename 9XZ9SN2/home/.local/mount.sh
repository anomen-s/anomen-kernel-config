#!/bin/sh -x

sudo cryptsetup --timeout 30 open --type luks $HOME/.local/secure.luks secure || exit 1

sudo mount /dev/mapper/secure  $HOME/secure-data

