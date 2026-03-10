#!/bin/bash

echo "Generating SSL certificate and key..."

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/ymouchta.key \
    -out /etc/ssl/certs/ymouchta.crt \
    -subj="/C=MA/ST=Tetouan/L=Martil/O=1337 MED School/OU=ymouchta/CN=ymouchta.42.fr"

echo "SSL certificate and key generated successfully."

nginx -g "daemon off;"