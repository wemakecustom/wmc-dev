#!/bin/bash

FILE="/tmp/out.$$"
GREP="/bin/grep"

# Root Only
if [[ $EUID -ne 0 ]]; then
   echo "You must run this script must as root" 1>&2
   exit 1
fi

# Update
apt-get update -y
apt-get upgrade -y

#Linux requirement
apt-get install -y vim git

#Vagrant
apt-get install -y linux-headers-$(uname -r)
apt-get install -y virtualbox vagrant

vagrant plugin install vagrant-persistent-storage
