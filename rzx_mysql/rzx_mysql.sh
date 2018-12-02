#!/bin/bash

if [ -z "$(ls -A /var/lib/mysql)" ]; then
    /usr/bin/mysql_install_db --user=root > /dev/null 2>&1
    nohup /usr/bin/mysqld_safe --user=root > /dev/null 2>&1 &
    sleep 2
    /usr/bin/mysqladmin -u root password 123456
    mysql -u root -p123456 < /opt/scripts/create_mysqldb.sql
    mysqld_safe_pid=$(ps -C mysqld_safe -o pid | awk 'NR==2')
	mysqld_pid=$(ps -C mysqld -o pid | awk 'NR==2')
	kill -9 "$mysqld_safe_pid"
	kill -9 "$mysqld_pid"
    sleep 2
fi

/usr/bin/mysqld_safe --user=root