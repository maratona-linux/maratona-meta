#!/bin/bash

# Function which try install a program of Snap in 3 tries.
# Defaults of requisition:
#   $1 - Name of package
#   $2 - Arg1 of snap (--classic or --edge)
#   $3 - Arg2 of snap (--classic or --edge)

try_install_snap() {
	try=0
	while [ $(snap list | grep $1 | wc -l) -eq 0 ] && [ $try -lt 3 ]; do
		snap install $1 $2 $3
	    try=$((try+1))
	done

	# In case of success, return 0. In case of failure, return 1.
	if [ $(snap list | grep $1 | wc -l) -eq 0 ]; then
		return 1
	else
		return 0
	fi
} 
