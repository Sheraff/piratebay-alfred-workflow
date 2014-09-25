#!/bin/bash

VAR="{query}"

if [[ -z "$VAR" ]]
	bundle="florian.piratebay"
	# cache="${HOME}/Library/Application Support/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/${bundle}"
	cache = "debug"

	# The location of the pid file
	PHP_PID_FILE="${cache}/php.pid"

	# Make the cache dir if it doesn't exit
	[[ ! -d "${cache}" ]] && mkdir -p "${cache}"

	function launch_php() {
	    nohup php -S localhost:6743 &> /dev/null &
	    PHP_PID=$(echo $!)
	    echo $PHP_PID > "${PHP_PID_FILE}"
	    return 0
	}

	function launch_kill_script() {
	    nohup ./kill_script.sh &> /dev/null &
	    return 0
	}

	[[ ! -f ${PHP_PID_FILE} ]] && launch_php && launch_kill_script
elif [[ -z "${VAR:1}" ]]; then
	cat zero.xml
else
	curl --max-time 1 localhost:6743/main_script.php "${VAR:1}"
fi