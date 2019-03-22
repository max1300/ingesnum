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

Nous allons configurer à présent les serveurs avec lesquels notre propre serveur DNS va dialoguer, cette étape n'est pas obligatoire.

Ces serveurs peuvent être soit les serveurs de noms de votre FAI, soit n'importe qu'elle autre serveur de noms. Pour notre exemple nous utilisons ceux de Google.
```
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
```
