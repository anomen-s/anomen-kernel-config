#!/usr/bin/env python

import RPi.GPIO as GPIO ## Import GPIO library
import time ## Import 'time' library. Allows us to use 'sleep'

# http://sourceforge.net/p/raspberry-gpio-python/wiki/BasicUsage/
# https://pypi.python.org/pypi/RPi.GPIO

PIN = 28 #changed from 7

print "respberry Pi Rev." + str(GPIO.RPI_REVISION)
print "Version " + GPIO.VERSION

GPIO.setmode(GPIO.BCM) ## Use board pin numbering or GPIO.setmode(GPIO.BCM)
GPIO.setup(PIN, GPIO.OUT, initial=GPIO.LOW) ## Setup GPIO Pin 7 to OUT
GPIO.setup(PIN+1, GPIO.OUT, initial=GPIO.HIGH) ## Setup GPIO Pin 7 to OUT
GPIO.setup(PIN+2, GPIO.OUT, initial=GPIO.LOW) ## Setup GPIO Pin 7 to OUT
GPIO.setup(PIN+3, GPIO.OUT, initial=GPIO.HIGH) ## Setup GPIO Pin 7 to OUT
# or: GPIO.setup(PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
# or: GPIO.setup(PIN, GPIO.OUT, initial=GPIO.HIGH)

##Define a function named Blink()
def Blink(numTimes,speed):
  for i in range(0,numTimes):## Run loop numTimes
     print "Iteration " + str(i+1)## Print current loop
     GPIO.output(PIN,True)## Switch on pin 
     time.sleep(speed)## Wait
     GPIO.output(PIN,False)## Switch on pin 
     GPIO.output(PIN+1,True)## Switch on pin 
     time.sleep(speed)## Wait

     GPIO.output(PIN+1,False)## Switch on pin 
     GPIO.output(PIN+2,True)## Switch on pin 
     time.sleep(speed)## Wait

     GPIO.output(PIN+2,False)## Switch on pin 
     GPIO.output(PIN+3,True)## Switch on pin 
     time.sleep(speed)## Wait

     GPIO.output(PIN+3,False)## Switch on pin 

     # 1==GPIO.HIGH==True 

  print "Done" ## When loop is complete, print "Done"
  #GPIO.cleanup()
  GPIO.cleanup( )


## Ask user for total number of blinks and length of each blink
iterations = 20
speed = 1

## Start Blink() function. Convert user input from strings to numeric data types and pass to Blink() as parameters
Blink(int(iterations),float(speed))
