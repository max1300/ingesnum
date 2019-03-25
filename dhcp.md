# Installer et configurer un serveur DHCP sous linux

Nous utiliserons le paquet `isc-dhcp-server` que nous installerons à l'aide la commande *APT*: `apt install isc-dhcp-server`

## Configuration

Le but pour nous sera de pouvoir mettre en place un serveur DHCP qui répondra sur notre interface eth0 et fournira des IPs de classe C (Pour rappel une adresse IP de classe C dispose de *trois octets* pour identifier le réseau et *d'un seul octet* pour identifier les machines sur ce réseau.)

Pour l'exercice nous retenons le réseau 192.168.1.0/24

Pour se faire nous éditerons le fichier `/etc/dhcp/dhcpd.conf`
De manière à y renseigner la configuration suivante:

```
## Type de mise à jour du DNS (aucune)
ddns-update-style none;

## Nom du serveur DHCP
server-name "ns-1.ingesnum.lan";

## Mode autoritaire (autoritaire)
authoritative;

default-lease-time 600;
max-lease-time 7200;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.1.255;
option routers 192.168.1.254;
option domain-name-servers 192.168.1.1, 192.168.1.2;
option domain-name "ingesnum.lan";

subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.10 192.168.1.100;
}
```

Nous définisons ici le «range» d'IP que nous allons distribuer à nos clients.

Commencons ensuite par indiquer sur quelle interface nous souhaitons proposer un service DHCP (dans notre cas `eth0`) en éditant `/etc/default/isc-dhcp-server`.

```
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid

# Additional options to start dhcpd with.
#   Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#   Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="eth0"
INTERFACESv6=""
```

Il faut pour finir indiquer au Raspberry comment lui doit se configurer pour pouvoir servir ses clients.
Pour cela nous éditerons le fichier `/etc/dhcpcd.conf` pour y modifier les lignes concernant `eth0` afin d'avoir la configuration suivante:

```
interface eth0
static ip_address=192.168.1.1/24
static domain_name_servers=192.168.1.1 8.8.8.8
```

Il est également possible d'assurer ses arrières et de faire en sorte que le Raspberry reste disponible sur le réseau même si le démarage du serveur DHCP se passe mal. En lui affectant une IP de «fall back» comme suit:

```
# It is possible to fall back to a static IP if DHCP fails:
# define static profile
profile static_eth0
static ip_address=192.168.1.1/24
static domain_name_servers=192.168.1.1 8.8.8.8
```
Arriver à ce stade nous pouvons redémarrer le Raspberry Pi qui devrait à présent être disponible sur l'IP *192.168.1.1*

NB: Il est possible de consulter les «leases» accorder par notre serveur dans le fichier `/var/lib/dhcp/dhcpd.leases`

## Affecter des adresses statiques à certains hôtes

Il «suffit» d'ajouter une directive «host» dans la définition du subnet. Le principe est de donner à un client une adresse précise en fonction de son adresse MAC.

On modifie donc le fichier de configuration `/etc/dhcp/dhcpd.conf` en y rajoutant les informations suivantes au niveau du subnet:

subnet 192.168.1.0 netmask 255.255.255.0 {
  host mysql-1 {
   hardware ethernet b8:27:eb:9d:11:1b;
   fixed-address 192.168.1.11;
  }
  host web-1 {
   hardware ethernet b8:27:eb:49:b9:8b;
   fixed-address 192.168.1.12;
  }
  range 192.168.1.10 192.168.1.100;
}


