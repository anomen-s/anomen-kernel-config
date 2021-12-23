#!/bin/sh

cd $HOME/bt
exec screen -S rt rtorrent -o "port_range=14405-14409,directory=$HOME/downloads"

# port range for tunnels on modem

