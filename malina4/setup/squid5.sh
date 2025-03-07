#!/bin/sh

# https://mindchasers.com/dev/squid

apt install libtool-bin

git clone https://github.com/squid-cache/squid.git squid

cd squid

git checkout v5

./bootstrap.sh

mkdir build
cd build

../configure --prefix=/opt/squid --with-default-user=squid --enable-ssl --disable-inlined \
--disable-optimizations --enable-arp-acl --disable-wccp --disable-wccp2 --disable-htcp \
--enable-delay-pools --enable-linux-netfilter --disable-translation --disable-auto-locale \
--with-logdir=/var/log/squid5 --with-pidfile=/run/squid5.pid


make

make install
