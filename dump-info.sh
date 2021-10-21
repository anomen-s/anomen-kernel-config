#!/bin/sh

LC_ALL=C

HOST=`uname -n`
REL=`uname -r`

echo "$HOST/$REL"
mkdir  -p "$HOST/$REL" || exit 1
chmod 777 "$HOST/$REL"

if [ `id -g` -ne 0 ]
  then echo "Please run as root"
  exit 2
fi

cd "$HOST/$REL"

run() {
 echo "### $1 $2"
 if type "$1"
 then
   eval "$1 $2" > "$3"
   chmod 666 "$3"
   if [ ! -s "$3" ]
   then
     rm -v "$3"
   fi
 else
   echo Not found: "$1"
 fi
}

for CMD in dmesg glxinfo hwinfo lshw lsmod vainfo uptime lscpu
do
 run "$CMD" "" "$CMD"
done

run "lspci" "-v" lspci-v
run "lsusb" "-t" lsusb-t
run "lsusb" "-v" lsusb-v
run "uptime" "-s" uptime-s
run "cat" "/proc/cpuinfo" cpuinfo
run "cat" "/proc/mounts" mounts
run "dpkg-query" "--list" dpkg-query-list
