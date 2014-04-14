FROM uggedal/alpine
MAINTAINER Eivind Uggedal <eivind@uggedal.com>

RUN apk -U add nginx

ADD nginx.conf /etc/nginx/nginx.conf

VOLUME ["/etc/nginx/conf.d", "/var/www", "/var/log/nginx"]

EXPOSE 80

ENTRYPOINT ["nginx"]
