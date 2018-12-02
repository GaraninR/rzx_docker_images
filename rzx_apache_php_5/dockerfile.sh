#!/bin/bash

INSTALL_DIR=/opt/install

zypper -n --no-gpg-checks in -y -f php5 \
    apache2-mod_php5 php5-mysql php5-mbstring php5-dom php5-gd \
    php5-json php5-mcrypt php5-zip php5-bz2 php5-iconv

awk -f $INSTALL_DIR/php.ini.awk /etc/php5/apache2/php.ini > /tmp/php.ini
cp /tmp/php.ini /etc/php5/apache2/

rm -rf /srv/www/htdocs/*
echo '<?php phpinfo(); ?>' > /srv/www/htdocs/index.php

a2enmod php5
a2enmod rewrite

rm -rf /tmp/*
rm -rf ${INSTALL_DIR}
chmod 777 -R /srv/*