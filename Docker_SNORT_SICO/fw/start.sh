#!/bin/bash
# Workarround para solventar el error que aparece si en la definici´on de la red ponemos
# como gateway la IP de m´aquina que queremos que ejerza como tal (en este caso, fw).
# No podemos poner IPs repetidas en el fichero docker-compose.yml

/iptables.sh

#snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/snort3-community.rules
#snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/snort3-community.rules -i eth1 -A full

/usr/sbin/sshd -D