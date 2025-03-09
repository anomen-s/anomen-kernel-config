#!/bin/sh

if [ $(hostname) = malina4b ]
then
 CMD=vncserver-virtual
else
 CMD=vncserver
fi

#screen -S vncserver 
$CMD -geometry 1024x768 -depth 16 :4
