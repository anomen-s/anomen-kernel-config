#!/bin/sh

HEIGHT=303

echo Internal:
INTT=`/opt/vc/bin/vcgencmd measure_temp`
INTV=`/opt/vc/bin/vcgencmd measure_volts`
INTF=`sed -n -e 's/\(.*\)000/\1MHz/p' /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
INTG=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
echo "$INTT $INTV freq=$INTF $INTG"


for BMP in /sys/bus/i2c/drivers/bmp085/*-*
do
 BT=`cat /sys/bus/i2c/drivers/bmp085/*/temp0_input`
 BP=`cat /sys/bus/i2c/drivers/bmp085/*/pressure0_input`
 # rel=(abs*9.80665*h)/(287*(273+t+(h/400)))+abs
 python -c "print('temp=' + '{0:.1f}'.format($BT / 10.0) + '\'C press='+ '{0:.1f}'.format($BP / 100.0) + 'hPa relPress=' + '{0:.1f}'.format($BP / 100.0 + $HEIGHT / 8.3) + 'hPa'  )"
done

echo External:

for A in  /sys/bus/w1/devices/*/w1_slave
do 
T=`sed -ne  "s/.*t=\(\w\w\w\w\w\).*/\1/p" $A `
python -c "print('temp=' + '{0:.1f}'.format($T / 1000.0) + '\'C' )"
done

#sed -ne  "s/.*t=\(\w\w\)\(\w\).*/temp=\1.\2'C/p" /sys/bus/w1/devices/*/w1_slave

