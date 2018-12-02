#!/bin/bash

INSTALL_DIR=/opt/install

SCRIPTS_PATH=/opt/scripts
ENTRYPOINT_SCRIPT=rzx_apache.sh
IMAGE_SCRIPT=rzx_apache.sh
STARTUP_SCRIPT=startup.sh

zypper -n --no-gpg-checks in -y -f apache2 w3m lynx

cp $INSTALL_DIR/default-server.conf /etc/apache2

chmod 777 -R /srv/*
echo 'APACHE_MODULES="actions alias auth_basic authn_file authz_host authz_groupfile authz_core authz_user autoindex cgi dir env expires include log_config mime negotiation setenvif ssl socache_shmcb userdir reqtimeout authn_core php5 deflate headers rewrite"' >> /etc/sysconfig/apache2
echo 'ServerName localhost' >> /etc/apache2/httpd.conf
echo "<html><h1>Welcome to RZX Apache Docker Image</h1></html>" >> /srv/www/htdocs/index.html

echo "#!/bin/bash" >> $SCRIPTS_PATH/$IMAGE_SCRIPT
echo "/usr/sbin/apache2ctl -D FOREGROUND" >> $SCRIPTS_PATH/$IMAGE_SCRIPT

echo "$SCRIPTS_PATH/$IMAGE_SCRIPT &" >> $SCRIPTS_PATH/$STARTUP_SCRIPT

rm -rf ${INSTALL_DIR}
chmod 777 -R /opt/scripts