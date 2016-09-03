#!/bin/bash

if ! whoami|grep -q root; then
  echo "Este comando deve ser executado com privilégios de root."
  echo "Uso: sudo $0"
  exit 1
fi

FORCE=false

if echo "$1 $2" | grep -q "\-f"; then
  FORCE=true
fi

IP="$1"
if ! egrep -q "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" <<< "$IP"; then
  printf "Digite o IP do servidor BOCA: "
  read IP

  if ! egrep -q "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" <<< "$IP"; then
    printf "Digite o IP do servidor boca.\n"
    exit 3
  fi
fi

RESP=0
if [[ "$FORCE" == "false" ]]; then
  ping -c1 -W1 $IP &>/dev/null
  RESP=$?
fi

if (( RESP == 0 )) || (( RESP == 1 )); then
  echo "BOCAIP=$IP" > /etc/bocaip

  if grep -q "\<boca-competidor$" /etc/hosts; then
    sed -i "/boca-competidor$/d" /etc/hosts
  fi
  printf "$IP\tbombonera.org boca boca-competidor\n" >> /etc/hosts
  printf "IP Adicionado com sucesso\n"
  exit 0

else (( RESP == 2 ))
  echo "IP inválido. NÃO ADICIONADO"
  echo "Execute este comando novamente para adicionar o IP correto"
  exit 2
fi
