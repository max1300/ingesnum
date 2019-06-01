# Virtualisation - Prise en main d'OpenStack

## Objectifs

- Découvrir le fonctionnement d'un cloud.
- Découvrir les différents composants d'OpenStack
- Prendre en main l'administration d'un nom de domaine
- Déployer une infrastructure destinée à servir des projets PHP/MySQL
- Augmenter la résilience d'une infrastructure grâce aux outils du cloud
- Mettre en place un certificat SSL

## Pré-requis

- Une clé SSH **personnelle**
- Un cloud provider proposant Openstack
- Un accès à Horizon (L'outil de pilotage web d'openstack)
- Un nom de domaine

## Introduction - Premier pas

Pour commencer nous allons créer un première machine virtuelle en nous connectant à l'interface Horizon d'openstack: https://horizon.cloud.ovh.net

**ATTENTION** «Mal nommer les choses, c'est ajouter au malheur du monde.» (Albert Camus)

Points à valider:

- Identifier les entreés proposées
- Savoir créer une instance
- Savoir rattacher un réseau
- Savoir rattacher un volume
- Savoir créer un security group et comprendre son fonctionnement.
- Savoir importer sa clé SSH
- Utiliser une IP failover
- Créer un script de post installation.

## Concevoir l'infrastructure

Notre infrastructure devra proposer différents éléments parmi lesquels:

- Un réseau privé (10.12.0.0/16)
- Un répartiteur de charge (HAProxy)
- Un serveur web (Nginx / PHP)
- Un serveur de noms
- Un serveur de base de données

Cette infrastructure disposera d'un seul point d'entrée publique, le répartiteur de charge qui sera ensuite chargé de «router» le reste sur le réseau privé.
Ce dernier sera également la passerelle par défaut du réseau privé et donc le point d'accès vers le web des conteneurs ne disposant pas d'infercace publique.

## Concevoir les images de base de nos conteneurs

Les images doivent embarquer les clés SSH nécessaires à leur bon fonctionnement, les paquets communs à l'ensemble des conteneurs.

### Répartiteur de charge / Gateway

Les répartiteur de charges on pour vocation d'être le point d'accès publique de notre infrastructure.
Il écoute donc sur le port 80 (443 avec TLS) afin de service nos requêtes HTTP.
Par simplification dans notre schema il aura également la charge de «gateway» et donc de router le traffic sortant.

### Configuration réseau

Le répartiteur de charge est particulier car il dispose de deux interfaces, une lui permettant de dialoguer sur le réseau privée, l'autre sur le réseau public.

La configuration réseau passe par l'API Openstack

 ```
 $ openstack port show e3ec145c-ad00-45a9-9ac9-1647ff323518
 $ openstack port set --fixed-ip subnet=4c611106-c998-42fb-885f-358291f96074,ip-address=10.12.0.1 e3ec145c-ad00-45a9-9ac9-1647ff323518
 $
 ```

Il est possible de supprimer un port réseau comme suit

```
openstack port unset --fixed-ip subnet=4c611106-c998-42fb-885f-358291f96074,ip-address=10.12.0.28 e3ec145c-ad00-45a9-9ac9-1647ff323518
```

Il nous faut à présent transformer notre LB en gateway en routant les paquets qui viennent du réseau privé vers «l'extétieur».

La configuration est identique à celle du [Raspberry](../../tutorials/raspberry.md).

Il nous reste à configurer notre LB de la même manière que l'exercice avec le [Raspberry](../../tutorials/haproxy.md) également

### Le serveur de noms

Il n'est accessible que sur le réseau privé

### Conteneur Web

Sa configuration est similaire à la configuration du [wordpress](../../tutorials/wordpress.md) moyennant quelques adaptations propres au projet que l'on souhaite faire fonctionner.

```
server {
    listen 10.12.0.19:80;
    server_name nuumfactory.fr;
    root /srv;
    location / {
        index index.php;
        try_files $uri $uri/ /index.php?$args;
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

### Conteneur de base de données

On y installera une base de données de type MariaDB comme vu avec l'exercice avec les [Rasp](../../tutorials/mariadb.md)

### Le stockage

Si l'on souhaite utiliser un volume «persistant» de manière à conserver les données même lors de la destuction du conteneur il est nécessaire d'utiliser un volume.

Après avoir créé un volume dans Horizon ou avec l'API il est nécessaire de le rattacher à une instance.
Une fois rattaché il nous faudra partitionner le volume en question et créer le système de fichier.

Identifier le disque que l'on souhaite utilisé

```
root@lb-1:/home/debian# sudo lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0  10G  0 disk
`-sda1   8:1    0  10G  0 part /
sdb      8:16   0   1G  0 disk
```

Une fois identifié on créer la partition:

```
sudo parted /dev/sdb mklabel gpt
```

```
sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%
```

Et on créer le système de fichier

```
sudo mkfs.ext4 -L datapartition /dev/sda1
```

### Les groupes de sécurité

### Cluster de DB

MariaDB embarque un cluster SQL appelé Galera permettant d'assurer de la haute disponibilité en terme de données et de renforcer la résilience des instances de stockage.

Ajouter un fichier `galera.cnf` dans `/etc/mysql/conf.d/`

```
[mysqld]
user = mysql
binlog_format = ROW
default-storage-engine = innodb
innodb_autoinc_lock_mode = 2
innodb_flush_log_at_trx_commit = 0
query_cache_type = 0
query_cache_size = 0
bind-address = 0.0.0.0

[galera]
wsrep_on = ON
wsrep_provider = /usr/lib/galera/libgalera_smm.so
wsrep_provider_options = gcache.size=300M; gcache.page_size=1G
wsrep_cluster_name = nuumfactory
wsrep_cluster_address = gcomm://10.12.0.193,10.12.0.151,10.12.0.92
wsrep_sst_method = rsync
wsrep_node_address = 10.12.0.193
wsrep_node_name = 10.12.0.193
```

Démarrer un serveur galera `galera_new_cluster` (uniquement le premier noeud)

Vérifier qu'il fonctionne correctement

```
mysql -uroot -e "SHOW STATUS LIKE 'wsrep%'"
```

Démarrer un noeud
```
systemctl start mysql
```
