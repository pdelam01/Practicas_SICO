#!/bin/bash
# Workarround para solventar el error que aparece si en la definici´on de la red ponemos
# como gateway la IP de m´aquina que queremos que ejerza como tal (en este caso, fw).
# No podemos poner IPs repetidas en el fichero docker-compose.yml

ip route del default via 10.5.1.254
ip route add default via 10.5.1.1

service apache2 start
service rsyslog start
service fail2ban start

#Redireccionamos el puerto 22 al 2222
iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222 

/usr/sbin/sshd -D

