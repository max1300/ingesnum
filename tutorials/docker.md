# Docker

## Introduction à Docker

Docker est une solution de virtualisation de type conteneur.

https://docs.docker.com

## Démarrer/Construire un conteneur

Il existe énormément d'image prêtes à l'utilisation misent à disposition par la communauté ou par les éditeurs de solutions.
Celles-ci sont disponibles sur [Dockerhub](https://hub.docker.com/)
Pour notre exemple nous utiliserons une simple image Nginx pour servir un fichier plat (Ne pas utiliser l'option `-d`)

## Construire une infrastructure plus complexe

Le but est ici de reproduire une infra web PHP/MySQL standard
Nous allons dans un répertoire projet `compose` créer un fichier `docker-compose.yml` qui ne contiendra pour l'instant qu'une seule ligne `version: '3.3'`
Nous créerons également un répertoire `my_project` contenant un fichier php affichant «hello World!»

### Le serveur web

Nous utiliserons l'image officiel Nginx (https://hub.docker.com/_/nginx) et ajouterons donc à notre fichier `docker-compose.yml`

```
version: '3.3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "8080:80"
```

On build/run `docker-compose up`. Dans un navigateur la page par défaut d'Nginx doit apparaitre (http://localhost:8080)

Nous allons ajouter un point de montage:

```diff
version: '3.3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "8080:80"
+   volumes:
+     - ./my_project:/srv
```

Et créer un nouveau répertoire `nginx` qui contiendra les configurations du serveur web

Dans ce répertoire nous créerons un fichier `myproject.conf` qui définira la configuration pour accéder à nos fichiers

```
server {
    server_name myproject.local;
    root /srv;
    index index.html;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
}
```

et nous le rajoutons dans compose

```diff
version: '3.3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "8080:80"
   volumes:
     - ./my_project:/srv
+    - ./nginx/myproject.conf:/etc/nginx/conf.d/myproject.conf
```

### Le conteneur PHP-FPM

Nous rajoutons un service php dans notre compose et on lie notre conteneur nginx au conteneur php

```
version: '3.3'
services:
  nginx:
    image: nginx:latest
    ports:
      - "8080:80"
   volumes:
     - ./my_project:/srv
     - ./nginx/myproject.conf:/etc/nginx/conf.d/myproject.conf
   links:
     - php
  php:
    image: php:7-fpm
```

Un `docker ps` doit normalement nous indiquer que les deux conteneurs fonctionnent:

```
⇒  docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                  NAMES
e9733b9c14ec        nginx:latest        "nginx -g 'daemon of…"   59 seconds ago       Up 57 seconds       0.0.0.0:8080->80/tcp   compose_nginx_1
844691f80eac        php:7-fpm           "docker-php-entrypoi…"   About a minute ago   Up 58 seconds       9000/tcp               compose_php_1
```

## Tips

### Ouvrir un shell sur un conteneur en cours de fonctionnement

`docker exec -it [container-id] /bin/bash

### Arrêter tous les conteneurs Docker:

`docker stop $(docker ps -a -q)`

### Supprimer tous les conteneurs

`docker rm $(docker ps -a -q)

### Supprimer toutes les images

`docker rmi --force $(docker images -q)`
