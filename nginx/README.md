nginx
=====

[Alpine Linux][a] image with [nginx][n].

Note that this image does not configure any
http `server` instances. Use other child images
with `--volumes-from` to do so.

Usage
-----

```sh
docker run -d -p 80:80 uggedal/nginx
```

License
-------

ISC

[a]: http://alpinelinux.org/
[n]: http://nginx.org/
