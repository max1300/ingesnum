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

## Tips

### Ouvrir un shell sur un conteneur en cours de fonctionnement

`docker exec -it [container-id] /bin/bash

### Arrêter tous les conteneurs Docker:

`docker stop $(docker ps -a -q)`

### Supprimer tous les conteneurs

`docker rm $(docker ps -a -q)

### Supprimer toutes les images

`docker rmi --force $(docker images -q)`
