#!/bin/bash

set -e

echo ''
echo 'INSTALLING'
echo '----------'

export DEBIAN_FRONTEND=noninteractive

echo "America/Montreal" > /etc/timezone
dpkg-reconfigure tzdata

# Add Google to the apt-get source list
if [ ! -e /etc/apt/sources.list.d/chrome.list ]; then
    wget -nv -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | apt-key add -
    echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list
fi

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)           main restricted universe multiverse" >  /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-updates   main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-security  main restricted universe multiverse" >> /etc/apt/sources.list

apt-get update
aptitude dist-upgrade -y
aptitude -y install openjdk-7-jre google-chrome-stable xvfb unzip

# Download and copy the ChromeDriver to /usr/local/bin

if [ ! -e /usr/local/bin/selenium-server-standalone-2.44.0.jar ]; then
    wget -nv "http://selenium-release.storage.googleapis.com/2.44/selenium-server-standalone-2.44.0.jar" -O /usr/local/bin/selenium-server-standalone-2.44.0.jar
fi

if [ ! -e /usr/local/bin/chromedriver ]; then
    mkdir /tmp/chromedriver
    cd /tmp/chromedriver
    wget -nv "http://chromedriver.storage.googleapis.com/2.13/chromedriver_linux64.zip"
    unzip chromedriver_linux64.zip
    mv chromedriver /usr/local/bin
    cd /
    rm -Rf /tmp/chromedriver
fi

apt-get autoremove -y
apt-get clean
rm -rf /tmp/* /var/tmp/*
