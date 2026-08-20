#!/bin/sh

F=xkeyboard-config-cz_prog-2022.patch

wget "https://raw.githubusercontent.com/anomen-s/anomen-overlay/master/x11-misc/xkeyboard-config/files/$F" -O "/tmp/$F"
S=`pwd`
cd /usr/share/X11/xkb

sudo patch -p1 < "/tmp/$F"
