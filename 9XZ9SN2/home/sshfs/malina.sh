#!/bin/sh

ssh  k.XXXXXXXXXX.info -p 1443 \
    -L 10080:localhost:80 \
    -L 15901:localhost:5901 \
    -M
