#!/usr/bin/env bash

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)           main restricted universe multiverse" >  /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-updates   main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-security  main restricted universe multiverse" >> /etc/apt/sources.list

aptitude update

aptitude dist-upgrade -y
