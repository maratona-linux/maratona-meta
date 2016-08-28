#!/bin/bash

if ! whoami|grep -q root; then
  echo "Este comando deve ser executado com privilégios de root."
  echo "Uso: sudo $0"
  exit 1
fi

printf "Digite o endereço do servidor proxy (ex: proxy.exemplo.com): "
read ENDERECO
printf "Digite a porta do servidor proxy (ex: 8080): "
read PORTA

printf "Digite o usuario do proxy: "
read USUARIO

printf "Digite a senha do proxy: "
read SENHA

ping -c1 -W1 $ENDERECO &>/dev/null
RESP=$?

#pegar IP do proxy
IP="$ENDERECO"
if echo "$ENDERECO" |grep -q "[a-zA-Z]"; then
  IP="$(host $ENDERECO |awk '{print $NF}')"
fi

if (( RESP == 0 )) || (( RESP == 1 )); then
  echo "http_proxy = http://$IP:$PORTA/" > /etc/wgetrc
  echo "use_proxy = on" >> /etc/wgetrc
  echo "proxy-user = $USUARIO" >> /etc/wgetrc
  echo "proxy-password = $SENHA" >> /etc/wgetrc

  VERSAO="$(wget http://www.bombonera.org/boca/version --timeout=5 -t 2 --quiet -O -|md5sum|awk '{print $1}')"
  if [[ "$VERSAO" != "b3eb7ea21da908f2c00eb3a755a6fa09" ]]; then
    echo "**ERRO**, Não adicionando o proxy"
    wget http://www.bombonera.org/boca/version --timeout=5 -t 2 -O -
    rm /etc/wgetrc
    echo "**ERRO**, Não adicionando o proxy"
    exit 2
  fi

  echo "PROXYIP=$IP" > /etc/proxyip

  printf "Proxy Adicionado com sucesso\n"
  exit 0

else (( RESP == 2 ))
  echo "Endereço inválido. NÃO ADICIONADO"
  echo "Execute este comando novamente para adicionar o IP correto"
  exit 2
fi
