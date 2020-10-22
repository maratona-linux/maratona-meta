#!/bin/bash

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Function which try install a program of Flathub in 3 tries.
# Defaults of requisition:
#   $1 - Name of package

try_install_flatpak() {
	try=0
	while [ $(flatpak list | grep $1 | wc -l) -eq 0 ] && [ $try -lt 3 ]; do
		flatpak install flathub $1 -y
	    try=$((try+1))
	done

	# In case of success, return 0. In case of failure, return 1.
	if [ $(flatpak list | grep $1 | wc -l) -eq 0 ]; then
		return 1
	else
		return 0
	fi
} 
