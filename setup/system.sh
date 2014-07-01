#!/bin/bash

FILE="/tmp/out.$$"
GREP="/bin/grep"

# Root Only
if [[ $EUID -ne 0 ]]; then
   echo "You must run this script must as root" 1>&2
   exit 1
fi

#VM Global Config
apt-get update -y
apt-get upgrade -y

#Linux requirement
apt-get install -y vim git

#Vagrant
apt-get install -y linux-headers-$(uname -r)
apt-get install -y  virtualbox vagrant nfs-kernel-server nfs-common portmap

vagrant plugin install vagrant-persistent-storage
