#!/bin/bash
erubis /etc/nginx/conf.d/upstream_ssl.conf.erb > /etc/nginx/conf.d/upstream_ssl.conf

/usr/sbin/nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
