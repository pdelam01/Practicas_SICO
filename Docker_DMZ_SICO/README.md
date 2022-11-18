# Práctica DMZ - Sistemas Confiables - MUIC - 2022/23

## Ficheros
Lista de los disitntos archivos y directorios que componen la práctica:
```
Docker_DMZ_SICO
├── run.sh                     # Script para parar y levantar los contenedores
├── README.md                 
├── docker-compose.yml         # Fichero de configuración de los contenedores
├── dmz.pdf                    # Documentación de la práctica
├── dmz/
│    ├── start.sh              # Script para iniciar la red de la DMZ
│    ├── sshd                  # Fichero de configuración del servicio SSH
│    ├── sshd_config           # Configuración del servidor SSH
│    ├── banner                # Banner de bienvenida del servidor SSH
│    ├── jail.conf             # Configuración de fail2ban
│    ├── index.html            # Página web de la DMZ HTTPS
│    ├── 000-default.conf      # Configuración del servidor Apache
│    └── Dockerfile            # Fichero de configuración del contenedor dmz
├── external/
│    ├── start.sh              # Script para iniciar la red externa
│    └── Dockerfile            # Fichero de configuración del contenedor external
├── internal/
│    ├── start.sh              # Script para iniciar la red interna
│    └── Dockerfile            # Fichero de configuración del contenedor internal
├── fw/
     ├── start.sh              # Script para iniciar el firewall
     ├── iptables.sh           # Script para configurar las reglas del firewall
     └── Dockerfile            # Fichero de configuración del contenedor fw    

```

## Implementación
Se han implementado todas las funcionalidades solicitadas en la práctica, incluyendo la configuración de los servicios OpenSSH Server y HTTPS. 

Para OpenSSH encontramos:
- Configuración de la conexión SSH en el puerto 2222
- No permitir la conexión con el usuario root
- Permitir el acceso por contraseña  siempre y cuando esta no esté vacía
- Permitir el acceso por clave pública
- Número máximo de intentos de conexión fallidos: 2
- Configuración de un banner de bienvenida
- Implementación de Fail2ban para detectar ataques de fuerza bruta y bloquear la IP del atacante
- Conexión multifactor con Google Authenticator

Para HTTPS encontramos:
- Configuración de la conexión HTTPS en el puerto 443
- Configuración de un certificado autofirmado
- Fichero index.html de bienvenida

## Salida comandos ip route e ip address
### Internal 1 & 2
```
root@650907a2deec:/# ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
49: eth0@if50: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:05:02:14 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.2.20/24 brd 10.5.2.255 scope global eth0
       valid_lft forever preferred_lft forever

root@650907a2deec:/# ip route
default via 10.5.2.1 dev eth0 
10.5.2.0/24 dev eth0 proto kernel scope link src 10.5.2.20 
```
```
root@248f9432a150:/# ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
45: eth0@if46: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:05:02:15 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.2.21/24 brd 10.5.2.255 scope global eth0
       valid_lft forever preferred_lft forever

root@248f9432a150:/# ip route
default via 10.5.2.1 dev eth0 
10.5.2.0/24 dev eth0 proto kernel scope link src 10.5.2.21 
```
### External
```
root@57c049e0028d:/# ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
43: eth0@if44: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:05:00:14 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.0.20/24 brd 10.5.0.255 scope global eth0
       valid_lft forever preferred_lft forever

root@57c049e0028d:/# ip route
default via 10.5.0.1 dev eth0 
10.5.0.0/24 dev eth0 proto kernel scope link src 10.5.0.20
```

### DMZ
```
root@744fce17c0a4:/# ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
47: eth0@if48: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:05:01:14 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.1.20/24 brd 10.5.1.255 scope global eth0
       valid_lft forever preferred_lft forever

root@744fce17c0a4:/# ip route
default via 10.5.1.1 dev eth0 
10.5.1.0/24 dev eth0 proto kernel scope link src 10.5.1.20
```
### Firewall
```
root@52380f69842e:/# ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
37: eth1@if38: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:05:00:01 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.0.1/24 brd 10.5.0.255 scope global eth1
       valid_lft forever preferred_lft forever
39: eth2@if40: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:05:02:01 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.2.1/24 brd 10.5.2.255 scope global eth2
       valid_lft forever preferred_lft forever
41: eth0@if42: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:0a:05:01:01 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.5.1.1/24 brd 10.5.1.255 scope global eth0
       valid_lft forever preferred_lft forever

root@52380f69842e:/# ip route
default via 10.5.1.254 dev eth0 
10.5.0.0/24 dev eth1 proto kernel scope link src 10.5.0.1 
10.5.1.0/24 dev eth0 proto kernel scope link src 10.5.1.1 
10.5.2.0/24 dev eth2 proto kernel scope link src 10.5.2.1 
```