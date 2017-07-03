#!/bin/sh
echo -n Password: 
read -s P
N=`expr substr  $P   10 1`
echo ""
P=`exec mvn --encrypt-password   "$P" `
echo $P $N
sed -i -e "s!.*@REPLACEPASS@.*!$P  $N @REPLACEPASS@!"  settings.xml && echo settings.xml updated
# 'NEW_PASSWORD'

