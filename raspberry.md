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
