# Configuration et installation d'un PHPMyAdmin

## Installation de phpMyAdmin

`apt install phpmyadmin --no-install-recommends`

Une fois l'installation terminée nous allons configurer notre serveur web (Nginx)

## Configuration de Nginx
Nginx va lire (pour Debian) ses fichier «hosts» dans `/etc/nginx/sites-enabled` c'est donc là que l'on va rajouter un fichier `phpmyadmin.conf`

`nano /etc/nginx/sites-enabled/phpmyadmin.conf`

Contenant:

```
server {
    listen 192.168.1.12;
    server_name _;
    root /usr/share/phpmyadmin;
    client_max_body_size 16M;
    location / {
        try_files $uri /index.php$is_args$args;
    }
    location ~ ^/.+\.php(/|$) {
    fastcgi_pass unix:/run/php7.0-fpm.sock;
    fastcgi_split_path_info ^(.+\.php)(/.*)$;
    fastcgi_read_timeout 60s;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
    fastcgi_param DOCUMENT_ROOT $realpath_root;
    fastcgi_param HTTPS off;
    }
}
```

Il est possible de vérifier que l'on a pas d'erreur de syntaxe avec la commande `nginx -t`

On peut ensuite redémarrer le service nginx `service nginx restart`

Il nous reste à indiquer à phpMyAdmin ou se trouve notre serveur de base de données en éditant le fichier `/etc/phpmyadmin/config-db.php`
Si le serveur de base de données fonctionne sur le même hôte il n'y a rien a faire. s'il est sur un autre noeud du réseau il faut modifier le fichier comme suit:

```
$dbuser='';
$dbpass='';
$basepath='';
$dbname='phpmyadmin';
$dbserver='IP_DE_NOTRE_SERVEUR';
$dbport='3306';
$dbtype='mysql';
```

## Utiliser un nom de domaine dédié

Il reste à résoudre le soucis du nom de domaine à utiliser pour joindre notre PMA.
On pourrait se contenter de l'IP mais cela va vite être génant si l'on souhaite faire tourner une autre application sur le même noeud.

Nous allons donc déclarer un alias dans notre zone DNS.

Sur notre serveur DNS nous allons donc rajouter dans `/etc/bind/zones/db.ingesnum.lan`:

L'enregistrement:

```
pma            IN      CNAME   web-1
```

A adapter en fonction du nommage que vous aurez choisi.

Il nous reste à modifier la section `server_name` au niveau du fichier de configuration de Nginx.

```
    listen 192.168.1.12;
    server_name pma.ingesnum.lan;
    root /usr/share/phpmyadmin;
    client_max_body_size 16M;
```

Et à redémarrer le service `service nginx restart`



