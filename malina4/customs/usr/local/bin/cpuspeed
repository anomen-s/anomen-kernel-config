#!/bin/sh

SYS=/sys/bus/cpu/devices/cpu0/cpufreq
N=
case $1 in
  max)
    N=`sed -e 's/.* \([0-9][0-9]*\)/\1/' $SYS/scaling_available_frequencies`
    ;;
  min)
    N=`sed -e 's/^\([0-9][0-9]*\) .*/\1/' $SYS/scaling_available_frequencies`
    ;;
  [0-9][0-9][0-9])
    N="${1}000"
    ;;
  [0-9][0-9][0-9][0-9])
    N="${1}000"
    ;;
  *)
    echo Invalid value: $N
    echo 'accepted: min, max, [MHz]'
    exit 1
esac

echo $N | sudo tee $SYS/scaling_max_freq


head \
   $SYS/scaling_available_frequencies \
   $SYS/scaling_max_freq \
   $SYS/scaling_min_freq \
   $SYS/scaling_cur_freq \

