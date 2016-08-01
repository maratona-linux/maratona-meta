=Maratona Linux=

Este repositório trata dos pacotes gerados para o PPA do Maratona Linux.

O Maratona Linux é constituído por um conjunto de pacotes que modificam uma
instalação padrão do ubuntu em Maratona Linux.

Esta modificação do Ubuntu é utilizada como ambiente de programação oficial
dos competidores da Maratona de Programação no Brasil.

=Instalação=

Todos os pacotes estão disponíveis no PPA:
https://launchpad.net/~brunoribas/+archive/ubuntu/ppa-maratona

Para instalar em um ubuntu basta:

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

=Compilando os pacotes=

WIP
