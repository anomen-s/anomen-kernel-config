#!/bin/sh
echo -n Password:
read -s PP
N=`expr substr  "$PP"   10 1`
echo ""
P=`exec mvn --encrypt-password   "$PP" `
echo $P $N
sed -i -e "s/.*@REPLACEPASS@.*/$P  $N @REPLACEPASS@/"  settings.xml && echo settings.xml updated
# 'NEW_PASSWORD'

W=`whoami`
T=`echo -n "$W:$PP" | base64`

sed -i -e "s/.*Authorization.*/AddHeader \"Authorization\" \"Basic $T\"/" tinyproxy.conf  && echo tinyproxy.conf updated
