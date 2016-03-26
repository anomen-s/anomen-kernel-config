#!/bin/sh

make clean

./configure  --enable-nonfree --enable-gpl --enable-lto \
 --enable-version3  --enable-gmp  --enable-libgsm  --enable-libmp3lame  --enable-librtmp --enable-libspeex --enable-libvpx --enable-libx264 \
 --enable-libvorbis --enable-libv4l2 --enable-libtwolame --enable-libopencore-amrwb --enable-libopencore-amrnb --enable-libtheora --enable-libcdio \
 --enable-thumb  --arch=armv7ve --cpu=cortex-a7 

#--disable-doc


make -j2 all


echo Install ?
read x

sudo make install
