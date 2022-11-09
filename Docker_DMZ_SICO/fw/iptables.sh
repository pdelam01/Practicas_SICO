#!/bin/bash

#Activamos bit de forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

#Cambiamos politicas por defecto: descartar los paquetes por las cadenas INPUT y FORWARD
iptables -P INPUT DROP
iptables -P FORWARD DROP

#Cambiamos la politica de OUTPUT para que permita pasar todos los paquetes
iptables -P OUTPUT ACCEPT

#Permitir trafico entrante a través de la interfaz loopback
iptables -A INPUT -i lo -j ACCEPT

#Permitir trafico entrante correspondiente a cualquier conexion previamente establecida
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#Permitir consultas entrantes de tipo ICMP echo-request
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

#Cadena FORWARD: permitir trafico de conexiones establecidas o relacionadas con TCP, UDP e ICMP
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT

#Trafico entrante por la red interna
#con protocolo TCP, UDP e ICMP
#con direccion IP origen 10.5.2.0/24
#y que salga por la interfaz de red externa
iptables -A FORWARD -i eth2 -s 10.5.2.0/24 -o eth1 -d 10.5.0.0/24 -m state --state NEW -p tcp -j ACCEPT
iptables -A FORWARD -i eth2 -s 10.5.2.0/24 -o eth1 -d 10.5.0.0/24 -m state --state NEW -p udp -j ACCEPT
iptables -A FORWARD -i eth2 -s 10.5.2.0/24 -o eth1 -d 10.5.0.0/24 -m state --state NEW -p icmp -j ACCEPT

#SNAT: los paquetes abandonen fw por interfaz externa y que vengan de la red interna
#deben cambiar su IP origen para que sea la de fw en esa interfaz 
iptables -t nat -A POSTROUTING -o eth1 -s 10.5.2.0/24 -j SNAT --to 10.5.0.1

#Acceso TCP desde cualquier maquina (interna o externa) a la maquina dmz1 (IP 10.5.1.20), exclusivamente al servicio HTTP (puerto 80).
iptables -A FORWARD -p tcp -o eth0 -d 10.5.1.20 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

#Dar acceso HTTPS
iptables -A FORWARD -p tcp -o eth0 -d 10.5.1.20 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

#Acceso SSH desde internal1 a dmz1
#iptables -A FORWARD -p tcp -i eth2 -s 10.5.2.20 -o eth0 -d 10.5.1.20 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -p tcp -i eth2 -s 10.5.2.20 -o eth0 -d 10.5.1.20 -m multiport --dports 22,2222 -m state --state NEW,ESTABLISHED -j ACCEPT
