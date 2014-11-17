#!/bin/bash

[ -e "/etc/apt/sources.list.d/thefanclub-grive-tools-$(lsb_release -cs).list" ] || add-apt-repository -y ppa:thefanclub/grive-tools

apt-get update

aptitude install grive-tools
