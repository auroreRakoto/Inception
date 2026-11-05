#!/bin/bash

# start-up
set -e

: "${MYSQL_DATABASE:?MYSQL_DATABASE is required}"
: "${MYSQL_USER:?MYSQL_USER is required}"
: "${MYSQL_PASSWORD:?MYSQL_PASSWORD is required}"
: "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD is required}"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ -f /var/lib/mysql/.initialized ]; then
    exec mariadbd --user=mysql
fi

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

wait "$pid" || true

# Mark database as initialized
touch /var/lib/mysql/.initialized
chown mysql:mysql /var/lib/mysql/.initialized

# mariadb launch
exec mariadbd --user=mysql

