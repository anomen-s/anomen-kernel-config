#!/bin/sh

HOST=vgerndvud633

ssh-add-once $HOME/.ssh/gemalto.priv  gemalto.priv

if [ -S "$HOME/.ssh/mastersock-adm3ggc1-$HOST-22" ]
then
 echo Control socket found. Press enter to delete it.
 read
 rm -v "$HOME/.ssh/mastersock-adm3ggc1-$HOST-22"
fi

screen -S $HOST-socket  ssh -o ConnectTimeout=40 -v -M $HOST "echo SOCKET OPENED to $HOST; while true; do echo -n .;sleep 1;done"

$HOME/sshfs/$HOST/mount.sh

