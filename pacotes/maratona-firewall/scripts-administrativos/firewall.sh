#!/bin/bash

function saidaerro()
{
  printf "Ops. IP do servidor boca não configurado.\n"
  printf "Informe o IP do servidor BOCA com o comando:\n"
  printf "    sudo config-ip-boca\n"
  exit 1
}

if [[ ! -e /etc/bocaip ]]; then
  saidaerro
fi

. /etc/bocaip

if [[ -e /etc/proxyip ]]; then
  . /etc/proxyip
fi

if [[ "x$BOCAIP" == "x" ]]; then
  saidaerro
fi

if ! whoami|grep -q root ; then
  printf "Este comando deve ser executado com privilégios de root.\n"
  exit 1
fi

ip6tables -X
ip6tables -t filter -F
ip6tables -P FORWARD DROP
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

iptables -X
iptables -t filter -F
iptables -t nat -F
iptables -P FORWARD DROP

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -P INPUT DROP
iptables -P OUTPUT DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -m limit --limit 1/s -j ACCEPT

#BOCA vale tudo
#so nao vale SSH
iptables -A OUTPUT -p tcp -d $BOCAIP --dport 22 -j REJECT

iptables -A INPUT  -p tcp -s $BOCAIP -j ACCEPT
iptables -A OUTPUT -p tcp -d $BOCAIP -j ACCEPT
iptables -A INPUT  -p udp -s $BOCAIP -j ACCEPT
iptables -A OUTPUT -p udp -d $BOCAIP -j ACCEPT

if [[ "x$PROXYIP" != "x" ]]; then
  iptables -A OUTPUT -p tcp -d $PROXYIP --dport 22 -j REJECT
  iptables -A INPUT  -p tcp -s $PROXYIP -j ACCEPT
  iptables -A OUTPUT -p tcp -d $PROXYIP -j ACCEPT
  iptables -A INPUT  -p udp -s $PROXYIP -j ACCEPT
  iptables -A OUTPUT -p udp -d $PROXYIP -j ACCEPT
fi

#DNS
#iptables -A OUTPUT -p tcp --syn -m state --state NEW --dport 53 -j ACCEPT
#iptables -A OUTPUT -p udp --dport 53 -j ACCEPT


iptables -A OUTPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A OUTPUT -p udp -j REJECT --reject-with icmp-net-unreachable

