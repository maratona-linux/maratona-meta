#!/bin/bash
if ! whoami|grep -q root ; then
  printf "Este comando deve ser executado com privilégios de root.\n"
  exit 1
fi

printf "Parando o firewall"
ipt="/sbin/iptables"
$ipt -P INPUT ACCEPT
$ipt -P FORWARD ACCEPT
$ipt -P OUTPUT ACCEPT
$ipt -F
$ipt -X
$ipt -t nat -F
$ipt -t nat -X
$ipt -t mangle -F
$ipt -t mangle -X
$ipt -t raw -X
echo ". feito"
