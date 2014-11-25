#!/bin/bash
# Apache functions - Lars Web Tools
#
# Usage:
# Always start by running `apache::init` to validate the apache
# installation and setup globals.
#
# Globals:
# $APACHE_DIR	Holds the path to the global apache configuration.

# Initialize this module
#
# @parameters void
apache::init() {
	vercomp "`apache::version`" "2.4.0"
	if [ $? -ne 1 ]; then
		abort "Apache 2.4.0 or later required."
	fi

	export APACHE_DIR="`apache::config_get "ServerRoot"`"

	if [ ! -d "${APACHE_DIR}/sites-available" ]; then
		abort "Could not find apache's site configuration directory."
	fi
}

# Check if a virtual host for domain exists
#
# @parameters DOMAIN
# @return 0 if virtual host exists.
apache::host_exists() {
	if [ "$#" -ne 1 ]; then abort "Not enough parameters."; fi

	local __host="${APACHE_DIR}/sites-available/${1}.conf"

	if [ -f "$__host" -o -h "$__host" ]; then
		return 0
	else
		return 1
	fi
}

# Create virtual host for domain
#
# @parameters DOMAIN PATH
apache::host_create() {
	if [ "$#" -ne 2 ]; then abort "Not enough parameters."; fi

	local __host="${APACHE_DIR}/sites-available/${1}.conf"
	local __path="$2"
	local __host_config=$(source ${SCRIPT_PATH}/lwt_vhost_conf)

	echo "$__host_config" > "$__path"
	sudo ln -s "$__path" "$__host"
}

# Enable virtual host form domain
#
# @parameters DOMAIN
apache::host_enable() {
	if [ "$#" -ne 1 ]; then abort "Not enough parameters."; fi

	local __domain="${1}.conf"

	sudo sh -c "a2ensite \"$__domain\" > /dev/null"
}

# Get Apache version
#
# @parameters void
# @stdout The Apache version.
apache::version() {
	apachectl -v &> /dev/null
	if [ $? -ne 0 ]; then
		abort "Error running \`apachectl -v\`."
	fi

	local apache_ver="`apachectl -v 2> /dev/null`"
	apache_ver=`echo "$apache_ver" | grep "Server version"`
	apache_ver=`expr "$apache_ver" : 'Server version: Apache/\(.*\) .*'`
	echo $apache_ver
}

# Get Apache configuration value
#
# @parameters KEY
# @output Apache configuration value for KEY.
apache::config_get() {
	if [ "$#" -ne 1 ]; then abort "Not enough parameters."; fi

	local __key=$1

	apachectl -t -D DUMP_RUN_CFG &> /dev/null
	if [ $? -ne 0 ]; then
		abort "Error running \`apachectl -t -D DUMP_RUN_CFG\`."
	fi

	local conf="`apachectl -S 2> /dev/null`"
	conf=`echo "$conf" | grep "${__key}"`
	conf=`expr "$conf" : "${__key}: \"\(.*\)\""`

	echo "$conf"
}
