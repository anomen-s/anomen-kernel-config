#!/bin/sh

while read URL
do
echo "###" "$URL"

$HOME/down/slimrat-1.1-beta2/src/slimrat "$URL"

sleep 60
done < list.txt
