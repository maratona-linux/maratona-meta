# Maratona Linux

Este repositório trata do pacote maratona-meta do Maratona Linux.

O Maratona Linux é constituído por um conjunto de pacotes que modificam uma
instalação padrão do ubuntu em Maratona Linux.

Esta modificação do Ubuntu é utilizada como ambiente de programação oficial
dos competidores da Maratona de Programação no Brasil.

Este pacote é a base para a instalação completa do Maratona Linux.

# Instalação

Todos os pacotes estão disponíveis no PPA:
https://launchpad.net/~brunoribas/+archive/ubuntu/ppa-maratona

Para instalar os pacotes, partimos da premissa de que você instalou o Ubuntu
16.04 para Desktop e fez todas as atualizações necessárias.

> **ATENÇÃO** em sua instalação do Ubuntu, **NÃO** utilize o login
> _icpc_. Este login é reservado para uso dos times e será criado
> automaticamente após a instalação dos pacotes.

Para instalar em um ubuntu basta:
(caso add-apt-repository não esteja instalado, use
sudo apt-get install software-properties-common python-software-properties)

```
sudo add-apt-repository ppa:brunoribas/ppa-maratona
sudo apt-get update
sudo apt-get install maratona-desktop
```

Se for utilizar o Maratona Linux em uma máquina virtual instale o pacote
maratona-desktop-virtual com o comando:

```
sudo apt-get install maratona-desktop-virtual
```

# TODO

Alguns pacotes gerados aqui não são meta, devem ser separados para ficar em
outro repositório.
