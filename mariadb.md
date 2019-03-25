# MariaDB

## Installation

`apt install mariadb-server`

Afin de rendre notre serveur accessible depuis d'autres noeuds de notre réseau nous allons ouvrir le fichier `mariadb.cnf` et commenter la ligne `!includedir /etc/mysql/mariadb.conf.d/` comme ci-dessous

```
# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
#!includedir /etc/mysql/mariadb.conf.d/
```

*ATTENTION* cette manipulation n'est pas à faire sur de la production qui demandera une configuration plus sérieuse.

Il nous reste à demander à notre serveur d'écouter sur toutes nos interfaces en éditant le fichier `/etc/mysql/conf.d/mysql.cnf` et en ajoutant:

```
[mysqld]
bind-address = 0.0.0.0
```

Et a redémarrer le serveur `service mariadb restart`

## Se connecter au serveur
(Par défaut l'utilisateur root lorsqu'il accède localement au serveur n'a pas de mot de passe)

`mysql -uroot`

## Lister les utilisateurs

`SELECT user, host, password, plugin FROM mysql.user;`

## Créer un utilisateur

CREATE USER 'ingesnum'@'192.168.1.%' IDENTIFIED BY 'mot_de_passe_solide';

Si l'on souhaite modifier le mot de passe d'un utilisateur

`SET PASSWORD FOR 'ingesnum'@'192.168.1.%' = PASSWORD('mot_de_passe_solide');`

## Créer une base de données

`CREATE DATABASE ma_base`;

## Donner des droits à un utilisateur sur une base de données

`GRANT ALL PRIVILEGES ON ma_table.* TO 'ingesnum'@'192.168.1.%';`

## Pour supprimer un utilisateur:

`DROP USER 'ingesnum'@'192.168.1.%';`


