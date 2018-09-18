#!/bin/bash

. /etc/comtrend.conf

M="$1"

test -n "$HOST" || M=conf
test -n "$PASSWORD" || M=conf


case "$M"C in
   deny)	URL="wlmacflt.cmd?action=save&wlFltMacMode=deny&sessionKey="
		;;
   disabled)	URL="wlmacflt.cmd?action=save&wlFltMacMode=disabled&sessionKey="
		;;
   add)		URL="wlmacflt.cmd?action=add&wlFltMacAddr=${2}&wlSyncNvram=1&sessionKey="
		;;
   conf)	echo "Missing or invalid /etc/comtrend.conf"
		exit 3
		;;
   ?)    	printf "Usage: %s: deny|disabled|add\n" $0
		exit 2
		;;
esac

SK=`curl -u "admin:$PASSWORD" "http://$HOST/wlmacflt.cmd?action=view" | sed -n -e 's/.*sessionKey=\([0-9]*\).*/\1/p' | head -n 1`

curl   -o /tmp/comtrend.html -u "admin:${PASSWORD}" "http://${HOST}/${URL}${SK}"

