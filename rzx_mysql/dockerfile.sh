#!/bin/bash

zypper -n --no-gpg-checks in -y -f mysql-community-server
mkdir /var/lib/mysql
mkdir /var/run/mysql

INSTALL_DIR=/opt/install
SCRIPTS_PATH=/opt/scripts
IMAGE_SCRIPT=rzx_mysql.sh
STARTUP_SCRIPT=startup.sh

PMA_VERSION=phpMyAdmin-4.8.3-all-languages
PMA_ARCH_NAME=$PMA_VERSION.zip
PMA_DOWNLOAD_LINK=https://files.phpmyadmin.net/phpMyAdmin/4.8.3/$PMA_ARCH_NAME

echo "<?php phpinfo(); ?>" >> /srv/www/htdocs/phpinfo.php

wget --directory-prefix=$INSTALL_DIR $PMA_DOWNLOAD_LINK
unzip /opt/install/$PMA_ARCH_NAME -d /tmp/pma
cp -a /tmp/pma/$PMA_VERSION/* /srv/www/htdocs
cp /tmp/config.inc.php /srv/www/htdocs/


echo "$SCRIPTS_PATH/$IMAGE_SCRIPT &" >> $SCRIPTS_PATH/$STARTUP_SCRIPT

chmod -R 777 /srv/www/htdocs
chmod 444 /srv/www/htdocs/config.inc.php
chmod -R 777 $SCRIPTS_PATH

rm -rf /tmp/*
rm -rf ${INSTALL_DIR}