#!/bin/bash
# Core functions - Lars Web Tools

# Echo debug info and exit
#
# @parameters STRING [...]
abort() {
	echo ${BASH_SOURCE[1]##*/}[${BASH_LINENO[0]}]: "${@}"
	echo "Aborting."
	exit 1
}

# Compare version strings
#
# vercomp by Dennis Williamson, see http://stackoverflow.com/a/4025065/1227116
#
# @parameters VERSION VERSION
# @return 0 if equal, 1 if left greater, 2 if right greater.
vercomp() {
	if [[ $1 == $2 ]]
	then
		return 0
	fi
	local IFS=.
	local i ver1=($1) ver2=($2)
	# fill empty fields in ver1 with zeros
	for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
	do
		ver1[i]=0
	done
	for ((i=0; i<${#ver1[@]}; i++))
	do
		if [[ -z ${ver2[i]} ]]
		then
			# fill empty fields in ver2 with zeros
			ver2[i]=0
		fi
		if ((10#${ver1[i]} > 10#${ver2[i]}))
		then
			return 1
		fi
		if ((10#${ver1[i]} < 10#${ver2[i]}))
		then
			return 2
		fi
	done
	return 0
}

# Confirm this action or exit
#
# @parameters STRING [...]
confirm_or_exit() {
	echo "$@"
	echo "Do you wish to continue? (y/n)"
	read REPLY
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		exit 1
	fi
}

# Ask for sudo
#
# @parameters STRING [...]
sudo_please() {
	echo "$@"
	sudo echo -n ""
	if [ $? -eq 1 ]; then
		abort "Permission denied"
	fi
}
