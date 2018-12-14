#!/bin/bash

D=`date '+%F %R'`

touch /var/log/arpstats.log
echo ${D} >> /var/log/arpstats.log
/usr/local/bin/arp-list >> /var/log/arpstats.log
