#!/bin/bash

# start-up
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# init
mariadbd --user=mysql --skip-networking &
pid="$!"

until mariadb-admin ping --silent; do
	sleep 1
done

# db creation
mariadb <<-EOF
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOF

mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

exec mariadbd --user=mysql

# user creation

# mariadb launch

