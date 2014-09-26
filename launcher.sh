#!/bin/bash

VAR="$1"
bundle="florian.piratebay"
cache=${HOME}/Library/Application\ Support/Caches/com.runningwithcrayons.Alfred-2/Workflow\ Data/${bundle}
PHP_PID_FILE="${cache}/php.pid"

# as soon as possible, try returning values
if [[ "${#VAR}" -eq 0 ]] || [[ "$VAR" == " " ]]; then
	# return statically stored result if query null
	cat zero.xml
elif [[ ${VAR:0:1} == " " ]] && [[ "${#VAR}" -gt 1 ]]; then
	# if process doesn't exist yet but there is a query, do it the old fashion way (will happen when using Alfred's history) otherwise use existing server
	if [[ ! -f ${PHP_PID_FILE} ]] || ( ! ps -p $(cat "${PHP_PID_FILE}") > /dev/null ); then
		php main_script.php "${VAR:1}"
	else
		curl localhost:6743/main_script.php -d query="${VAR:1}"
	fi
fi

# make the cache dir if it doesn't exit
[[ ! -d "${cache}" ]] && mkdir -p "${cache}"

# kickoff thread handling scripts if process doesn't exist
if [[ ! -f ${PHP_PID_FILE} ]] || ( ! ps -p $(cat "${PHP_PID_FILE}") > /dev/null ); then
	# launch php and store the PID
	nohup php -S localhost:6743 &> /dev/null &
	echo $! > "${PHP_PID_FILE}"
	# launch kill script
	nohup ./kill_script.sh &> /dev/null &
fi

#remember last trigger time
echo $(date +%s) > "${cache}/last" &