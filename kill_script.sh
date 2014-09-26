#!/bin/bash

bundle="florian.piratebay"
cache=${HOME}/Library/Application\ Support/Caches/com.runningwithcrayons.Alfred-2/Workflow\ Data/${bundle}

# The location of the pid file
PHP_PID_FILE=${cache}/php.pid

[[ ! -f "${PHP_PID_FILE}" ]] && exit 1 # the PHP pid file doesn't exist... whoops.

# Read the pid from the pid file
PHP_PID=$(cat "${PHP_PID_FILE}")

# Sleep for a bit... commented out for debug
sleep 20

# Set the flag to die as false
die=0
# We'll stay in a while loop until we're told to die.
while [[ $die -eq 0 ]]; do
  # see if we get a response from the webserver
  [[ $(curl --max-time 1 localhost:6743/ping.php) == "pong" ]] && sleep 1 || die=1

  # Check to see if the status file has been updated
  updated=$(cat "${cache}/last") # this is a file that the PHP script updates
  now=$(date +%s) # this is now
  updated=$(( $updated + 40 )) # this is an adjusted time
  # if the server hasn't shown activity in the last 20 seconds, kill it
  [[ $now -gt $updated ]] && die=1

  # sleep for 20 seconds and try it again
  sleep 20

done

kill $PHP_PID

[[ -f "${cache}/php.pid" ]] && rm "${cache}/php.pid"
[[ -f "${cache}/last" ]] && rm "${cache}/last"

exit 0