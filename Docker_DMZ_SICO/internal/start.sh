#!/bin/bash
# Workarround para solventar el error que aparece si en la definici´on de la red ponemos
# como gateway la IP de m´aquina que queremos que ejerza como tal (en este caso, fw).
# No podemos poner IPs repetidas en el fichero docker-compose.yml
ip route del default via 10.5.2.254
ip route add default via 10.5.2.1

/usr/sbin/sshd -D