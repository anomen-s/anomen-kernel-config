#!/bin/sh

HOST=vgerndvud633

screen -S $HOST-tunels-ssh  \
  ssh -v \
    -L 8060:vip_nfc:8060      \
    -L 47001:vip_srm:47001    \
    -L 47002:vip_srm:47002    \
    -L 47003:vip_srm:47003    \
    -L 49155:vip_nfc:49155    \
    -L 20080:vip_gui:20080    \
    -L 30080:vip_gui:30080    \
    -R 9018:localhost:9018    \
    -L 1524:vip_nfc:1524    \
    -L 1525:vip_nfc:1525    \
    -L 20301:vip_pm3gnfc:20301 \
	-o ConnectTimeout=40      \
  $HOST "echo TUNELS $HOST; while true; do echo -n .;sleep 10;done"
