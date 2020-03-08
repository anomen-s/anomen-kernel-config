#!/bin/sh

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 2
fi

HOST=`uname -n`
REL=`uname -r`

echo "$HOST/$REL"
mkdir  -p "$HOST/$REL" || exit 1
chmod 777 "$HOST/$REL"

cd "$HOST/$REL"

run() {
 echo "$1 $2"
 if type "$1"
 then
   eval "$1 $2" > "$3"
   chmod 666 "$3"
 else
   echo Not found: "$1"
 fi
}

for CMD in dmesg glxinfo hwinfo lshw lsmod vainfo
do
 run "$CMD" "" "$CMD"
done
run "lspci" "-v" lspci-v
run "lsusb" "-t" lsusb-t
run "lsusb" "-v" lsusb-v
