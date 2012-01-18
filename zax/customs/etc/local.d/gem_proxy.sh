
# anomen: support for gem. proxy server

if [ -n  "`/sbin/ip addr show  to 10.50/16`" ]; then
 # PRG
 export http_proxy=http://10.55.0.36:8080
 export https_proxy=http://10.55.0.36:8080
fi

if [ -n  "`/sbin/ip addr show  to 10.10/16`" ]; then
 #LaCiotat
 export http_proxy=http://10.2.120.201:8080
 export https_proxy=http://10.2.120.201:8080
fi

