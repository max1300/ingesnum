## Installation d'HAProxy

L'introduction du balanceur de charge nous permettra de se faire une idée de ce qu'est une infrastructure redondée et comment les infrastructures deviennent aussi résilientes.

`apt install haproxy`

## Configuration

La configuration d'HAProxy se fait dans le fichier `/etc/haproxy/haproxy.cfg` qui contient déja certaines informations.
Nous allons y rajouter nos directives.

```
frontend frontend_http
    bind 192.168.1.13:80

    mode    http
    option  httplog
    option  forwardfor    # Insert x-forwarded-for header so that app servers can see both proxy and client IPs

    reqadd X-Forwarded-Proto:\ http

    default_backend www-backend

backend www-backend
    mode http

    server web-1 192.168.1.12:80 maxconn 50 check inter 10s
    server web-2 192.168.1.14:80 maxconn 50 check inter 10s
```

On teste notre configuration `haproxy -f /etc/haproxy/haproxy.cfg  -c`
Et on redémarre le service `service haproxy restart`

## Quelques stats

Il est possible d'avoir quelques informations succintes concernant notre LB en ajoutant les directives suivantes:

```
listen stats
    bind    192.168.1.13:8880
    mode    http
    option  httplog
    option  forwardfor    # Insert x-forwarded-for header so that app servers can see both proxy and client IPs

    stats enable
    stats hide-version
    stats realm Haproxy\ Statistics
    stats uri /
    stats auth admin:mot_de_passe
```
