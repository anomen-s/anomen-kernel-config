#!/bin/sh

CMD=`realpath -s "$0"`

HOST=`echo "$CMD" | sed -e 's@.*/\(.*\)/mount.sh@\1@'`

#HOST=172.17.2.156

if [ "X$HOST" = "Xsshfs" ]
then
 echo invalid hostname
 exit
fi

echo connecting to $HOST...

# keep ciphering // -o Cipher=none
exec sshfs  -o workaround=rename -o nonempty -o transform_symlinks,reconnect,ConnectTimeout=20  $HOST:/ $HOME/sshfs/$HOST
