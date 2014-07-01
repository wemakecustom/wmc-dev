#!/usr/bin/env bash

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

######
# Preinstall and custom repos
######
apt-get install -y python-software-properties

# ElasticSearch
wget -nv -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
echo "deb http://packages.elasticsearch.org/elasticsearch/1.0/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

# PHP Stable
add-apt-repository -y ppa:ondrej/php5

# PHP Composer
add-apt-repository -y ppa:duggan/composer

# NodeJs
add-apt-repository -y ppa:chris-lea/node.js

# Percona
apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
echo "deb http://repo.percona.com/apt $(lsb_release -cs) main" > /etc/apt/sources.list.d/percona.list
echo "deb-src http://repo.percona.com/apt $(lsb_release -cs) main" >> /etc/apt/sources.list.d/percona.list

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



######
# Install
######
apt-get update

aptitude dist-upgrade -y

cat "/media/vagrant/setup/packages.list" | xargs aptitude install -y linux-headers-`uname -r`

npm install -g bower

rsync -av "/media/vagrant/setup/files/" /

######
# Configure
######

# PHP
for module in extras apcu curl gd gmp imagick intl json mcrypt mysqli mysql mysqlnd pdo pdo_mysql pdo_sqlite readline tidy xsl; do
  php5enmod $module
done
sed -i "s/www-data/vagrant/" /etc/php5/fpm/pool.d/www.conf

# Apache
for module in rewrite alias actions vhost_alias setenvif proxy proxy_http; do
  a2enmod $module
done
a2ensite wmc.conf
sed -i "s/www-data/vagrant/" /etc/apache2/envvars
chown -R vagrant:vagrant /var/lib/apache2/

[ -d /media/data/projects ] || mkdir /media/data/projects
chown vagrant: /media/data/projects

[ -e /var/www/wmc ] && rm /var/www/wmc
ln -sfv /media/data/projects /var/www/wmc

[ -e /home/vagrant/projects ] && rm /home/vagrant/projects
ln -sfv /media/data/projects /home/vagrant/projects

# PEAR
pear -q upgrade pear
pear -q channel-discover pear.phpunit.de
pear -q channel-discover components.ez.no
pear -q channel-discover pear.symfony.com

service php5-fpm restart
service apache2 restart
service dnsmasq restart

# wget -nv https://gist.githubusercontent.com/lavoiesl/3864795/raw/gitconfig -O /home/wmc/.gitconfig


