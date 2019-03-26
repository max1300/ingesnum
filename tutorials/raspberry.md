# Prise en main du Raspberry

## Installer Raspbian

Pour commencer nous avons besoin d'un OS, allons donc télécharger Raspbian ici: https://downloads.raspberrypi.org/raspbian_lite_latest

Il nous faudra également de quoi écrire un système «bootable» sur une carde SD, nous utiliserons BalenaEtcher: https://www.balena.io/etcher/

Afin d'activer le serveur SSH il est nécessaire de déposer un fichier vide appeler `ssh` à la racine de la carte SSD. Raspbian activera le service SSH au premier démarrage et supprimera le fichier.

## Trouver l'adresse de son Raspberry

Nous pouvons utiliser Wireshark pour analyser les paquets réseau échangés entre notre machine et le Raspberry de manière à trouver son adresse IP.

Une fois l'ip récupérée nous pouvons nous connecter via SSH `ssh pi@169.254.214.114`
(L'utilisateur par défaut du Raspberry est *pi* et il a pour mot de passe *raspberry*.)

## Configurer le wifi

Pour activer le wifi il nous faudra modifier le fichier `/etc/wpa_supplicant/wpa_supplicant.conf` en y ajoutant la configuration suivante:

```
network={
    ssid="testing"
    psk="testingPassword"
}
```

Après modification (`sudo nano /etc/wpa_supplicant/wpa_supplicant.conf`) votre fichier doit donc contenir les informations suivantes:

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="Mon SSID"
    psk="Cleduwifi"
}
```

Il faut pour terminer relancer la configuration du réseau avec la commande `sudo wpa_cli -i wlan0 reconfigure`
Vous pouvez vérifier que votre Raspberry est correctement connecté en vérifiant les connexions réseau (`ip a`), s'il a réussi à rejoindre votre réseau vous devriez observer un status *UP* sur l'interface et constater qu'il a récupérer une adresse IP.

```
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0f:00:a3:e6:7d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::2423:b63:fd14:21c9/64 scope link
       valid_lft forever preferred_lft forever
```

Une fois connecté nous pouvons mettre à jour notre Raspberry via *APT*: `apt update`

## Donner une IP statique à son Raspberry

La procédure de Raspbian pour affecter une IP statique à son Raspberry passe par dhcpcd (et non pas par `/etc/network/interfaces`).

Il nous faut donc éditer le fichier `/etc/dhcpcd.conf`:

`nano /etc/dhcpcd.conf`

Et modifier la section «static IP configuration» comme ci-dessous:

```
interface eth0
static ip_address=192.168.1.2/24
#static ip6_address=fd51:42f8:caae:d92e::ff/64
#static routers=192.168.1.1
static domain_name_servers=192.168.1.2 8.8.8.8
```

Cette configuration permet au Raspberry, dans le cas ou aucun serveur DHCP n'est disponible sur le réseau de prendre l'IP `192.168.1.2`

## Transformer son Raspberry Pi en passerelle internet.

Si vous disposez d'un Raspberry Pi avec deux interfaces réseau (Wifi et Ethernet) vous pouvez le transformer relativement facilement en passerelle internet et partager votre connexion avec l'ensemble des machines que vous lui connecterez.

Première étape, activer le routage IP en modifiant le fichier: `/etc/sysctl.conf`

`nano /etc/sysctl.conf`

Et on décommente la ligne `net.ipv4.ip_forward=1`

Il nous reste à router les paquets arrivant sur l'interface `eth0` vers l'interface `wlan0`, nous utiliserons iptables pour le faire:

```
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
```

Pour terminer nous allons persister ses règles à l'aide du paquet `iptables-persistent`, s'il n'est pas déja installé, faites le: `apt install iptables-persistent`

On sauvegarde nos règles `iptables-save > /etc/iptables/rules.v4` et on redémarre pour vérifier qu'elles sont correctement chargées.









