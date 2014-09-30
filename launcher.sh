#!/bin/bash
split_symbol=" ➔ "
min_query=3

VAR="$1"
bundle="florian.piratebay"
cache=${HOME}/Library/Application\ Support/Caches/com.runningwithcrayons.Alfred-2/Workflow\ Data/${bundle}
PHP_PID_FILE="${cache}/php.pid"

# as soon as possible, try returning values
if [[ "${#VAR}" -eq 0 ]]; then
	# return statically stored result if query null
	cat zero.xml
elif [[ "${#VAR}" -gt 0 ]]; then
	# give more time to php server to boot by handling first chars here
	if [[ "${#VAR}" -lt $((min_query + 1)) ]]; then
		xml="<?xml version=\"1.0\"?><items>"
		while read line; do
			# category id case
			key=${line:0:3}
			if [[ ${key:1:2} == "00" ]]; then
				main_cat=${line:4}
				name=$main_cat
			else
				name="$main_cat$split_symbol${line:4}"
			fi
			words=$(echo ${line:4} | sed -e 's/[^a-zA-Z0-9]/ /g' | tr '[:upper:]' '[:lower:]')
			query_test=$(echo $VAR | sed -e 's/[^a-zA-Z0-9]/ /g' | tr '[:upper:]' '[:lower:]')
			# if [[ "$words" =~ $query_test ]] ; then
			# 	xml="$xml<item uid=\"$key\" arg=\"$name\" valid=\"no\" autocomplete=\" $name$split_symbol\"><arg>$name</arg><title>$name</title><subtitle>Tab to search for $name only</subtitle></item>"
			# fi
			for word in $words; do
				if [[ ${word:0:${#query_test}} == $query_test ]]; then
					xml="$xml<item uid=\"$key\" arg=\"$name\" valid=\"no\" autocomplete=\"$name$split_symbol\"><arg>$name</arg><title>$name</title><subtitle>Tab to search for $name only</subtitle></item>"
					break
				fi
			done
		done <list.txt
		echo "$xml</items>"
	else
		# if process doesn't exist yet but there is a query, do it the old fashion way (will happen when using Alfred's history) otherwise use existing server
		if [[ ! -f ${PHP_PID_FILE} ]] || ( ! ps -p $(cat "${PHP_PID_FILE}") > /dev/null ); then
			php main_script.php "$VAR"
		else
			curl localhost:6743/main_script.php -d query="$VAR"
		fi
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