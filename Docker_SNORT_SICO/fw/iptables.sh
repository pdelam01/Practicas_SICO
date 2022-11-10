#!/bin/bash

#Activamos bit de forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

#Cambiamos politicas por defecto: descartar los paquetes por las cadenas INPUT y FORWARD
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT

#Cambiamos la politica de OUTPUT para que permita pasar todos los paquetes
iptables -P OUTPUT ACCEPT
 
#Acceso al puerto 22 de la maquina dmz1 desde la red externa
iptables -A INPUT -p tcp -i eth1 -o eth0 --dport 22 -j ACCEPT

# Acceso al puerto 22 de la maquina dmz1 desde la red externa.
#iptables -t nat -A PREROUTING -p tcp - --dport 22 -j DNAT --to 10.5.1.20:2222
#iptables -A FORWARD -p tcp -i eth1 -o eth0 --dport 22 -j ACCEPT 
#iptables -t nat -A PREROUTING -p tcp -s 10.5.0.20 --dport 22 -j DNAT --to-destination 10.5.1.20:2222