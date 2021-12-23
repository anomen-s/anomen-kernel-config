#!/bin/sh

apt-get install build-essential cmake libbluetooth-dev libsdl2-dev \
 libcurl4-openssl-dev libenet-dev libfreetype6-dev libharfbuzz-dev \
 libjpeg-dev libogg-dev libopenal-dev libpng-dev \
 libssl-dev libvorbis-dev libmbedtls-dev pkg-config zlib1g-dev libsqlite3-dev


#wget https://github.com/supertuxkart/stk-code/releases/download/1.3/SuperTuxKart-1.3-src.tar.xz
#tar xvf SuperTuxKart-*-src.tar.xz
#cd SuperTuxKart-*-src/src

git clone https://github.com/supertuxkart/stk-code stk-code
svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets

mkdir -p stk-code/cmake_build
cd stk-code/cmake_build

cmake -DSERVER_ONLY=ON  -DBUILD_RECORDER=off -DCMAKE_INSTALL_PREFIX=/opt/stk ..

nice make -j4

sudo make install

