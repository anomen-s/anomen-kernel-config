#!/bin/sh

ssh-add $HOME/.ssh/anomen-overlay-git
ssh-add-once $HOME/.ssh/gemalto.priv  gemalto.priv

if [ "x$1" = "xloop" ]
then

# HOST=$2
# PORT=$3
 while true
  do

 if  ip  addr | grep -q 172.17.2.
 then
    HOST=banan
    PORT=22
 else
    HOST=kolovraty.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    PORT=443
 fi
 echo Will connect to : $HOST:$PORT

    if [ -S "$HOME/.ssh/mastersock-ludek-$HOST-$PORT" ]
    then
     echo Control socket found. deleting it.
     rm -v "$HOME/.ssh/mastersock-ludek-$HOST-$PORT"
    fi

   echo Connecting...
   
   ssh -v -M \
    -L 10080:localhost:80 \
    -L 15222:talk.google.com:5222 \
    -L 13128:banan:10128 \
    -L 3128:localhost:10128 \
    -L 3127:localhost:10128 \
    -R 22022:localhost:22 \
    -L 15900:localhost:5900 \
    -L 15901:localhost:5901 \
   $HOST "date;echo $HOST SOCKET/TUNELS; keep-alive 5"
   
   date
   echo Connection lost, wait and retry...
   sleep 10
  done

  exit 1 # to be sure ...
fi


#B=`realpath "$0"`
screen -S banan-tunels-ssh  /bin/sh "$0" loop

#./$HOST/mount.sh
