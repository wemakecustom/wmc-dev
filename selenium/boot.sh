#!/bin/bash

set -e

# Start Xvfb, Chrome, and Selenium in the background
# export DISPLAY=:10
# cd /vagrant

# echo "Starting Xvfb ..."
# Xvfb :10 -screen 0 1366x768x24 -ac -extension RANDR &

# echo "Starting Google Chrome ..."
# google-chrome --remote-debugging-port=9222 &

# echo "Starting Selenium ..."
cd /usr/local/bin
xvfb-run -s "-screen 0 1366x768x24" java -jar ./selenium-server-standalone-2.44.0.jar &
# DISPLAY=:1 xvfb-run java -jar ./selenium-server-standalone-2.44.0.jar &
