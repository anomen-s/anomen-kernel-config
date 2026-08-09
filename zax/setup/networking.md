# Network configuration

## Vbox
* 1: eth bridge
* 2: wifi bridge
* 3: NAT

## ifconfig
* enp0s3 down
* enp0s8 down
```
enp0s9: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.4.15  netmask 255.255.255.0  broadcast 10.0.4.255
        inet6 fe80::4779:caf:57f:109f  prefixlen 64  scopeid 0x20<link>
        inet6 fd17:625c:f037:4:75d4:e396:5642:a50d  prefixlen 64  scopeid 0x0<global>
        ether 08:00:27:5b:ba:ee  txqueuelen 1000  (Ethernet)
        RX packets 29452621  bytes 38079010564 (35.4 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 10974240  bytes 1465879860 (1.3 GiB)
        TX errors 0  dropped 25 overruns 0  carrier 0  collisions 0
```

## route
```
$ LC_ALL=C LANG=C route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.0.4.2        0.0.0.0         UG    1004   0        0 enp0s9
10.0.4.0        0.0.0.0         255.255.255.0   U     1004   0        0 enp0s9
127.0.0.0       127.0.0.1       255.0.0.0       UG    0      0        0 lo
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 br-01721329c9f7
172.20.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0

```
