# Installer et configurer d'un serveur de nom sous linux

Pour cette étape, nous allons installer le paquet bind9 `apt install bind9`
4 fichiers vont principalement nous interesser:

```
/etc/default/bind9
/etc/bind/named.conf
/etc/bind/named.conf.options
/etc/bind/named.conf.local
```

Comme nous n'allons utiliser qu'ipV4 nous allons passer bind en mode «IPv4»

`sudo nano /etc/default/bind9`

Et on y ajoute

`OPTIONS="-u bind -4"`

## Configuration du fichier d'options

`sudo nano /etc/bind/named.conf.options`

Avant toute chose nous allons définir quelles sont les machines qui peuvent soliciter notre serveur DNS, en effet il n'y a aucune raison de laisser un serveur DNS ouvert, en fait très peu d'acteurs sur internet peuvent y trouver un intérêt.

`sudo nano /etc/bind/named.conf.options`

Au dessus du bloc d'options nous allons rajouter notre réseau de manière à autoriser l'ensemble des machines qui y sont:

```
acl "trusted" {
        192.168.1.0/24;
};
```

Nous allons à présent rajouter après la directive `directory` les options suivantes:

```
recursion yes;
allow-recursion { trusted; }; # On autorise les requêtes récursives des clients que l'on a autorisés.
listen-on { 192.168.1.1; };   # Adresse IP de notre serveur Raspberry
allow-transfer { none; };     # Pas de transfert de zone
```

Nous pouvons redémarrer le service: `sudo service bind9 restart`

Si l'on trace la résolution DNS de `www.ingesnum.org` (`dig +trace www.ingesnum.org`) on peut voir que nous solicitons directement les serveurs racines.

```

; <<>> DiG 9.10.3-P4-Raspbian <<>> +trace http:/www.ingesnum.org
;; global options: +cmd
.           102684  IN  NS  k.root-servers.net.
.           102684  IN  NS  g.root-servers.net.
.           102684  IN  NS  d.root-servers.net.
.           102684  IN  NS  h.root-servers.net.
.           102684  IN  NS  i.root-servers.net.
.           102684  IN  NS  m.root-servers.net.
.           102684  IN  NS  l.root-servers.net.
.           102684  IN  NS  a.root-servers.net.
.           102684  IN  NS  j.root-servers.net.
...

org.            172800  IN  NS  d0.org.afilias-nst.org.
org.            172800  IN  NS  a0.org.afilias-nst.info.
org.            172800  IN  NS  c0.org.afilias-nst.info.
org.            172800  IN  NS  a2.org.afilias-nst.info.
...

ingesnum.org.       86400   IN  NS  ns-39-a.gandi.net.
ingesnum.org.       86400   IN  NS  ns-114-c.gandi.net.
ingesnum.org.       86400   IN  NS  ns-153-b.gandi.net.
...

ingesnum.org.       10800   IN  SOA ns1.gandi.net. hostmaster.gandi.net. 1521294774 10800 3600 604800 10800
;; Received 111 bytes from 213.167.230.154#53(ns-153-b.gandi.net) in 16 ms
```

Nous allons configurer à présent les serveurs avec lesquels notre propre serveur DNS va dialoguer, cette étape n'est pas obligatoire, ne pas le faire vous permet de notamment maitriser que vos requêtes DNS ne passe pas par des serveur tiers et de vous protéger vous et votre vie privée de tout un tas de choses ;)

Ces serveurs peuvent être soit les serveurs de noms de votre FAI, soit n'importe quels autres serveurs de noms. Pour notre exemple nous utiliserons ceux de Google.

```
forwarders {
    8.8.8.8;
    8.8.4.4;
};
```

Nous avons à présent un serveur DNS fonctionnel qui peut nous permettre de faire nos résolutions.

## Définir nos zones locales

Nous allons à présent définir la zone `ingesnum.lan` qui nous servira de zone de résolution locale.

`sudo nano /etc/bind/named.conf.local`

```
zone "ingesnum.lan" {
    type master;
    file "/etc/bind/zones/db.ingesnum.lan";
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.1.168.192";
};
```

## Création des fichiers de zones

Nous allons copier et modifier le fichier `db.local` qui nous servira de base pour la création de notre fichier de zone.

`sudo mkdir /etc/bind/zones`
`sudo cp /etc/bind/db.local /etc/bind/zones/db.ingesnum.lan`
`sudo nano /etc/bind/zones/db.ingesnum.lan`

```
$TTL    604800
@       IN      SOA     ns-1.ingesnum.lan. admin.ingesnum.lan. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

; name servers - NS records
@    IN      NS      ns-1.ingesnum.lan.
@    IN      NS      ns-2.ingesnum.lan.

; name servers - A records
ns-1          IN      A       192.168.1.1
ns-2          IN      A       192.168.1.2

; 192.168.1.0/24 - A records

```

Il nous reste à présent à configurer la zone inverse.
Comme précedemment nous utilisons un fichier comme modèle `sudo cp /etc/bind/db.127 /etc/bind/zones/db.1.168.192`

`sudo nano /etc/bind/zones/db.1.168.192`

Où nous renseignons nos enregistrements inverses.

```
$TTL    604800
@       IN      SOA     ns-1.ingesnum.lan. admin.ingesnum.lan. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

; name servers - NS records
@    IN      NS      ns-1.ingesnum.lan.
@    IN      NS      ns-2.ingesnum.lan.

; PTR Records
1   IN      PTR     ns-1.ingesnum.lan.
2   IN      PTR     ns-2.ingesnum.lan.
```
