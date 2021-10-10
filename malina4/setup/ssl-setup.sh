#!/bin/sh

CERTDIR=/etc/ssl/localcerts

rm -r -v -f $CERTDIR/*

mkdir -p $CERTDIR
chmod 710 $CERTDIR
chown root:www-data $CERTDIR

openssl req -new -x509 -days 3650 -nodes -out "$CERTDIR/apache_pub.pem" -keyout "$CERTDIR/apache.key"
openssl x509 -in "$CERTDIR/apache_pub.pem" -text -out "$CERTDIR/apache.pem"

rm -v -f t "$CERTDIR/apache_pub.pem"

a2enmod ssl
a2ensite malina4-ssl
systemctl restart apache2

# let's encrypt

#apt install certbot python-certbot-apache
