# Installation

Se rendre sur https://www.netacad.com et s'y créer un compte, télécharger packet tracer: https://www.netacad.com/group/offerings/packet-tracer/

Regarder l'introduction au fonctionnement de packet tracer: https://373583482.netacad.com/courses/833969

## Exercice:

Nous ne nous attacherons pas pour cet exercice à découper «proprement» les différents sous réseaux de l'entreprise.
Le but est ici de prendre en main Packet Tracer.

Vous êtes chargé de mettre en oeuvre le réseau interne d'une PME disposant de 2 sites, un à Paris et un à Lyon.

Les réseaux respectifs doivent être conçus comme ci dessous:

### Lyon

À Lyon on trouve la DSI et le service Marketing, le service Marketing dispose de 4 postes fixes, la DSI de 3 postes fixes.

- Le réseau de l'entreprise sera de la forme 192.168.1.0/24
- Les IPs allant à 1 à 10 seront réservées au fonctionnement de l'infrastructure de l'entreprise (Routeurs, serveurs ...)
- Les IPs disponibles pour les clients iront de 50 à 100
- L'IP publique du site de Lyon fournie par son FAI sera 78.192.146.191/8

#### Le site de Lyon dispose au niveau de son infrastructure

- D'un serveur DHCP
- D'un serveur DNS
- D'un serveur WEB permettant de servir l'intranet de l'entreprise.

ATTENTION ! Par choix interne la DSI disposera de son propre réseau qui sera de la forme 172.16.1.0/24 et de son propre serveur DHCP

Le réseau local de la DSI doit toutefois pouvoir communiquer avec le réseau local du reste de l'entreprise et inversement.

### Paris

À Paris on retrouveras la direction administrative et les commerciaux qui sont répartis sur 2 étages et qui disposent respectivement de 4 postes.

- Le réseau local sera, comme à Lyon de la forme 192.168.1.0/24
- Les IPs allant de 11 à 20 seront réservées au fonctionnement de l'infrastructure de l'entreprise (Routeurs, serveurs ...)
- Les IPs disponibles pour les clients iront de 101 à 1.151
- L'IP publique du site de Paris fournie par son FAI sera 98.42.24.18/12

#### Le site de Paris dispose au niveau de son infrastructure

- D'un serveur DHCP
- D'un serveur DNS

### Itinérants

Chacun des deux sites disposent de personnel en itinérance qui auront donc besoin d'un point d'accès sans fil (WPA2)

### Matériel

Ne chercher pas des composants trop compliqués la plupart du temps ceux-ci feront parfaitement l'affaire:

- PT Router
- PT Switch
- Switch 365024PS
- PT Server
