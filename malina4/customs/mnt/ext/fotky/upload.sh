#!/bin/sh

if [ ! -d "$1" ]
then
 echo invalid parameter
 exit 1
fi

T=`head -n 1 $HOME/.config/ftp-upload-target`
URL=`head -n 2 $HOME/.config/ftp-upload-target | tail -n 1`

zip -r -0 "${1}.zip" "${1}" || exit 2

curl -T "${1}.zip" "${T}/${1}.zip"

echo $URL/${1}.zip
