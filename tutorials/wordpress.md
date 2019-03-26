# Installation, pour l'exemple, de Wordpress

## Installation

`cd /srv/`

On récupère ensuite l'archive qui le contient: `wget https://fr.wordpress.org/latest-fr_FR.tar.gz`
que l'on décompresse: `tar xvfz latest-fr_FR.tar.gz`

## Création d'un nouvel alias dans notre zone DNS

```
wp             IN      CNAME   web-1
```

## Configuration Nginx

On créé un fichier de configuration, au hasard `/etc/nginx/sites-enabled/wordpress.conf` dans lequel on rajoute les directives de configuration suivantes:

```
server {
    listen 192.168.1.12;
    server_name wp.ingesnum.lan;
    root /srv/wordpress;
    rewrite /wp-admin$ $scheme://$host$uri/ permanent;
    location / {
        index index.php;
        try_files $uri $uri/ /index.php?$args;
    }
    location ~ ^/(\.|wp-config.php|readme.html|license.txt) {
        return 404;
    }
    location ~ [^/]\.php(/|$) {
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        fastcgi_read_timeout 60s;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        fastcgi_param HTTPS off;
    }
}
```

Sans oublier de vérifier la syntaxe `nginx -t` et de redémarrer notre service `service nginx restart`.
