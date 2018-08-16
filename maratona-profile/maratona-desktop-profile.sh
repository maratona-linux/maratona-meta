# Percorre todos os arquivos.desktop na home do usuario de deixa
# Os arquivos confiaveis
#if [ ! -f "$HOME/.config/desktop-trusted" ] ; then

for x in $HOME/Desktop/*.desktop ; do
	[ -f $x ] && gio set $x "metadata::trusted" yes
done

#echo "yes" > $HOME/.config/desktop-trusted
#fi
