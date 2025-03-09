#!/bin/sh

sudo apt install libgpiod-dev

rm -v -f gpio_blink25
gcc -o gpio_blink25 gpio_blink25.c -lgpiod

sudo cp -v gpio_blink25 /usr/local/sbin/
sudo chmod 755 /usr/local/sbin/gpio_blink25
