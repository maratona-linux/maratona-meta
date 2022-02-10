#!/bin/bash

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Function which try install a program of Flathub in 3 tries.
# Defaults of requisition:
#   $1 - Name of package

try_install_flatpak() {
	try=0
	while [ "$(flatpak list | grep "$1" | wc -l)" -eq 0 ] && [ $try -lt 3 ]; do
		flatpak install flathub "$1" -y
	    try=$((try+1))
	done

	# In case of success, return 0. In case of failure, return 1.
	if [ "$(flatpak list | grep "$1" | wc -l)" -eq 0 ]; then
		return 1
	else
		return 0
	fi
}

# Tries to remove a flatpak
# Arguments:
# $1 - package name
try_remove_flatpak() {
	if flatpak remove --assumeyes "$1"; then
		return 0
	else
		return 1
	fi
}

# Tries to install an specific version of a flatpak
# If no version is specified, installs the ropository's default
# Arguments:
# $1 - package name
# $2 - package version
# Return codes:
# 0 - package successfully installed
# 1 - package could not be installed
# 2 - failed to install the required version
# 3 - failed to install the required version and remove the current one
try_install_flatpak_version() {
	local try=0
	local -r max_tries=3

	if try_install_flatpak "$1"; then
		# no version specified
		if [ ! "$2" ]; then
			return 0
		fi

		while ! flatpak update --assumeyes --commit="$2" "$1" && [ "${try}" -lt "${max_tries}" ]; do
			try=$((try+1))
		done

		local current_ver
		current_ver=$(flatpak info --show-commit "$1")
		local ver_status=$?

		if [ "${ver_status}" -ne 0 ]; then
			if [ "${current_ver}" == "$2" ]; then
				return 0
			else
				if try_remove_flatpak "$1"; then
					return 2
				else
					return 3
				fi
			fi
		fi
	else
		return 1
	fi
}
