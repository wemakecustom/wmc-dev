#!/usr/bin/env bash

sed -i "s/www-data/vagrant/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/www-data/vagrant/" /etc/apache2/envvars
chown -R vagrant:vagrant /var/lib/apache2/

[ -d /media/data/projects ] || mkdir /media/data/projects
chown vagrant: /media/data/projects
[ -L ~/wmc-projects ] || ln -sv /media/data/projects ~/wmc-projects

if [ ! -L /var/lib/mysql ]; then
    mv /var/lib/mysql /media/data/
    ln -sv /media/data/mysql /var/lib/
fi
