#!/usr/bin/env bash

# Stop on first error
# http://www.davidpashley.com/articles/writing-robust-shell-scripts/#id2382181
set -e

export DEBIAN_FRONTEND=noninteractive

if [[ -d "/home/vagrant" ]]; then
  export HOME="/home/vagrant"
fi

echo "America/Montreal" > /etc/timezone
dpkg-reconfigure tzdata

######
# Preinstall and custom repos
######
apt-get install -y python-software-properties wget

# ElasticSearch
if [ ! -e /etc/apt/sources.list.d/elasticsearch.list ]; then
    wget -nv -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
    echo "deb http://packages.elasticsearch.org/elasticsearch/1.0/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list
fi

# PHP Stable
[ -e "/etc/apt/sources.list.d/ondrej-php5-$(lsb_release -cs).list" ] || add-apt-repository -y ppa:ondrej/php5

# PHP Composer
[ -e "/etc/apt/sources.list.d/duggan-composer-$(lsb_release -cs).list" ] || add-apt-repository -y ppa:duggan/composer

# NodeJs
[ -e "/etc/apt/sources.list.d/chris-lea-node_js-$(lsb_release -cs).list" ] || add-apt-repository -y ppa:chris-lea/node.js

# Git
[ -e "/etc/apt/sources.list.d/git-core-ppa-$(lsb_release -cs).list" ] || add-apt-repository -y ppa:git-core/ppa

# HHVM
if [ ! -e /etc/apt/sources.list.d/hhvm.list ]; then
    wget -nv -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
    echo "deb http://dl.hhvm.com/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/hhvm.list
fi

# Mongo
if [ ! -e /etc/apt/sources.list.d/mongodb.list ]; then
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
fi

# Percona
if [ ! -e /etc/apt/sources.list.d/percona.list ]; then
    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
    echo "deb http://repo.percona.com/apt $(lsb_release -cs) main" > /etc/apt/sources.list.d/percona.list
    echo "deb-src http://repo.percona.com/apt $(lsb_release -cs) main" >> /etc/apt/sources.list.d/percona.list
fi

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)           main restricted universe multiverse" >  /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-updates   main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-security  main restricted universe multiverse" >> /etc/apt/sources.list

# http://serverfault.com/questions/322400/install-mysql-server-and-set-password-from-the-command-line
# /var/lib/dpkg/info/percona-server-server-5.6.config
echo percona-server-server-5.6 percona-server-server/root_password password root | debconf-set-selections
echo percona-server-server-5.6 percona-server-server/root_password_again password root | debconf-set-selections

# PhpMyAdmin
# https://github.com/mauserrifle/vagrant-debian-shell/blob/master/install-phpmyadmin.sh
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean false' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/setup-password password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/database-type select mysql' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections

echo 'dbconfig-common dbconfig-common/mysql/app-pass password root' | debconf-set-selections
echo 'dbconfig-common dbconfig-common/mysql/app-pass password' | debconf-set-selections
echo 'dbconfig-common dbconfig-common/password-confirm password root' | debconf-set-selections
echo 'dbconfig-common dbconfig-common/app-password-confirm password root' | debconf-set-selections
echo 'dbconfig-common dbconfig-common/app-password-confirm password root' | debconf-set-selections
echo 'dbconfig-common dbconfig-common/password-confirm password root' | debconf-set-selections


apt-get update
aptitude dist-upgrade -y

######
# Install
######

aptitude install -y \
  apache2 \
  apache2-mpm-worker \
  aptitude \
  bash-completion \
  build-essential \
  elasticsearch \
  dnsmasq \
  gettext \
  git \
  hhvm \
  htop \
  iftop \
  imagemagick \
  libapache2-mod-fastcgi \
  "linux-headers-$(uname -r)" \
  mongodb-org \
  mytop \
  nodejs \
  node-uglify \
  percona-server-server-5.6 \
  php-{pear,gettext} \
  php5-composer \
  php5-{apcu,cli,curl,dev,fpm,gd,gmp,imagick,intl,json,mongo,mcrypt,mysqlnd,readline,recode,sqlite,tidy,xsl} \
  phpmyadmin \
  phpunit \
  siege \
  subversion \
  tmux \
  unrar \
  unzip \
  vim \
  zsh \

npm install -g bower less uglifycss
npm update -g

if [[ -d "/vagrant/setup/files" ]]; then
    rsync -av "/vagrant/setup/files/" /
else
    echo "WARNING: You must rsync setup/files/ into / yourself" >&2
fi

wget -nv https://gist.githubusercontent.com/lavoiesl/6e4de808a291b8665445/raw/php-extras.ini -O /etc/php5/mods-available/extras.ini

wget -nv https://gist.githubusercontent.com/lavoiesl/3867674/raw/wmc-clone.sh -O /usr/local/bin/wmc-clone.sh
chmod +x /usr/local/bin/wmc-clone.sh

wget -nv https://gist.githubusercontent.com/lavoiesl/2227920/raw/wordpress-change-url.php -O /usr/local/bin/wordpress-change-url.php
chmod +x /usr/local/bin/wordpress-change-url.php

# wget -nv https://gist.githubusercontent.com/lavoiesl/3864795/raw/gitconfig -O /home/wmc/.gitconfig
wget -nv https://gist.githubusercontent.com/lavoiesl/3864795/raw/gitignore -O /etc/gitignore

######
# Configure
######

[ -f "/vagrant/setup/vagrant-guest.sh" ] && bash "/vagrant/setup/vagrant-guest.sh"

# PHP
for module in extras apcu curl gd gmp imagick intl json mcrypt mongo mysqli mysql mysqlnd pdo pdo_mysql pdo_sqlite readline tidy xsl; do
  php5enmod $module
done

# Apache
for module in rewrite alias actions vhost_alias setenvif proxy proxy_http; do
  a2enmod $module
done
a2ensite wmc

[ -e /var/www/wmc ] && rm /var/www/wmc
ln -sv "${HOME}/wmc-projects" /var/www/wmc

# MongoDB
mongo admin --eval 'db.dropUser("wmc"); db.createUser({user: "wmc", pwd: "wmc", roles:[{role: "userAdminAnyDatabase", db: "admin"}]})'

# PEAR
pear -q upgrade pear
for channel in pear.phpunit.de components.ez.no pear.symfony.com; do
    pear list-channels | grep -qF $channel || pear -q channel-discover $channel
done

apt-get autoremove -y
apt-get clean
rm -rf /tmp/* /var/tmp/*

for service in php5-fpm apache2 dnsmasq mysql; do
    service $service restart
done
