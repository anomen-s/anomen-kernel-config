#!/bin/bash

D=`date +%F`

S=`cat /sys/class/net/eth0/statistics/{rx_bytes,rx_packets,tx_bytes,tx_packets}`
touch /var/log/netstats.log
echo -n "${S}" | tr '\n' '\t' >> /var/log/netstats.log
echo "	${D}" >> /var/log/netstats.log

