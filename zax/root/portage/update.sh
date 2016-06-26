#! /bin/sh

LDIR=/var/lib/layman

echo "#####" "Last sync: "
genlop -r |tail -n 2

echo "#####" layman
/usr/bin/layman -S

echo "#####" chown
chown lhlavace:portage -R "${LDIR}/anomen"

echo "#####" emerge --sync


if [ -n "${http_proxy}" ]
then
 emerge-webrsync
else
 /usr/bin/emerge --ignore-default-opts --sync --verbose
fi


eix-update
eix-layman add

