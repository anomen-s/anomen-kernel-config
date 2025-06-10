# Setup
* https://www.microsoft.com/en-us/software-download/windows10

# Make bootable Flash drive
* https://rufus.ie/

# Activation
* https://py-kms.readthedocs.io/en/latest/
* https://github.com/SystemRage/py-kms
```
docker run -d --name py-kms --restart always -p 1688:1688 -v /etc/localtime:/etc/localtime:ro ghcr.io/py-kms-organization/py-kms
```

```
slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
slmgr /skms malina4b.lan:1688 
slmgr /ato
```

# Hosts
```
c:\Windows\System32\drivers\etc
```
