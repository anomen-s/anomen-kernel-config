#!/bin/sh

wget https://raw.githubusercontent.com/anomen-s/anomen-overlay/master/x11-misc/xkeyboard-config/files/xkeyboard-config-cz_prog-2019.patch -O /tmp/xkeyboard-config-cz_prog-2019.patch

cd /usr/share/X11/xkb

sudo patch -p1 < /tmp/xkeyboard-config-cz_prog-2019.patch
