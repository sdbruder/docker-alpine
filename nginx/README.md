nginx
=====

[Alpine Linux][a] image with [nginx][n].

Usage
-----

```sh
docker run -d -p 80:80 uggedal/nginx
```

You can also mount host directories as container volumes:

```sh
docker run -d -p 80:80 \
  -v <confd-dir>:/etc/nginx/conf.d \
  -v <www-dir>:/var/www \
  -v <log-dir>:/var/log/nginx \
  uggedal/nginx
```

[a]: http://alpinelinux.org/
[n]: http://nginx.org/
