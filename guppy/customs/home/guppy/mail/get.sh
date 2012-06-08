#!/bin/sh

BASEDIR="$HOME/mail"
MB=`ls -I '*.sh'  "$BASEDIR" `
URL="http://www.mailinator.com/rss.jsp?email=$MB"
D=`date '+%Y-%m-%dT%H.%S'`
F="$BASEDIR/$MB/$D.rss.xml"

wget -q -O $F $URL
