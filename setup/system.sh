#!/bin/bash

#VM Global Config
apt-get update -y
apt-get upgrade -y

#Linux requirement
apt-get install -y vim git

#Vagrant
apt-get install -y linux-headers-$(uname -r)
apt-get install -y  virtualbox vagrant nfs-kernel-server nfs-common portmap

#Git Submodule
git submodule init
git submodule update

