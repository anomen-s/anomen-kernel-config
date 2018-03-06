#!/bin/sh

while true 
do
 kill `ps ax |sed -ne '/10080:localhost:[8]0/s/^\s*\([0-9]*\).*/\1/p'` 
 echo killed
 sleep 3600
done

