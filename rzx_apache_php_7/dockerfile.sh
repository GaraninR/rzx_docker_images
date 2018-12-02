#!/bin/bash

INSTALL_DIR=/opt/install

zypper -n --no-gpg-checks in -y -f php7 \
    apache2-mod_php7 php7-mysql php7-mbstring php7-dom php7-gd \
    php7-json php7-mcrypt php7-zip php7-bz2 php7-iconv

awk -f $INSTALL_DIR/php.ini.awk /etc/php7/apache2/php.ini > /tmp/php.ini
cp /tmp/php.ini /etc/php7/apache2/

rm -rf /srv/www/htdocs/*
echo '<?php phpinfo(); ?>' > /srv/www/htdocs/index.php

a2enmod php7
a2enmod rewrite

rm -rf /tmp/*
rm -rf ${INSTALL_DIR}
chmod 777 -R /srv/*