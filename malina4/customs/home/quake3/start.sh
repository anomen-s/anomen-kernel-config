#!/bin/sh

# see https://github.com/roguephysicist/q3a-server

screen -d -m -S quake3 \
 /usr/lib/ioquake3/ioq3ded  '+exec' server.cfg '+exec' levels.cfg '+exec' bots.cfg
