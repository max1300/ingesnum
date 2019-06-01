# Virtualisation - Prise en main d'OpenStack

## Objectifs

- Découvrir le fonctionnement d'un cloud.
- Découvrir les différents composants d'OpenStack
- Prendre en main l'administration d'un nom de domaine
- Déployer une infrastructure destinée à servir des projets PHP/MySQL
- Augmenter la résilience d'une infrastructure grâce aux outils du cloud
- Mettre en place un certificat SSL

## Pré-requis

- Une clé SSH ** personnelle*
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

Il nous faut à présent transformer notre LB en gateway en routant les paquets qui viennent du réseau privé vers «l'extétieur».

La configuration est identique à celle du Raspberry.

Il nous reste à configurer notre LB de la même manière que l'exercice avec le [Raspberry](../../tutorials/haproxy.md) également

### Le serveur de noms

Il n'est accessible que sur le réseau privé

### Conteneur Web

### Conteneur de base de données

### Le stockage
iu!<u>@@</u>


