#!/bin/bash

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

adduser --disabled-password --gecos "" $FTP_USER

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "$FTP_USER" >> /etc/vsftpd.userlist

mkdir -p /var/www/html

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd.conf