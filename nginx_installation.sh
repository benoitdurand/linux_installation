#!/bin/sh

wget http://nginx.org/download/nginx-1.11.5.tar.gz
tar -zxvf nginx-1.11.5.tar.gz
cd nginx-1.11.5
sudo ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-debug --with-pcre --with-http_ssl_module --with-http_v2_module --without-http_geo_module

sudo make
sudo make install

sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
sudo mkdir /etc/nginx/conf.d
