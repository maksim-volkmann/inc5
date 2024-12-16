#!/bin/bash
set -e

# Ensure correct ownership for /var/lib/mysql inside the container
chown -R mysql:mysql /var/lib/mysql

# SECRETS
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASS=$(cat /run/secrets/db_pass)
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)

# Check if database directory already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing database..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	# Start MariaDB temporarily without networking for setup
	mysqld --user=mysql --skip-networking &
	pid=$!

	echo "Waiting for MariaDB to start..."
	while ! mysqladmin ping --silent; do
		sleep 1
	done

	echo "Setting up MariaDB..."

	mysql -u root <<EOF
	-- Create database if not exists
	CREATE DATABASE IF NOT EXISTS ${DB_NAME};

	-- Create user if not exists and grant privileges
	CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';

	-- Alter root user to use mysql_native_password
	ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_ROOT_PASS}');

	FLUSH PRIVILEGES;
EOF

	echo "Shutting down temporary MariaDB instance..."
	mysqladmin -u root -p${DB_ROOT_PASS} shutdown

	echo "Restarting MariaDB in normal mode..."
	exec mysqld --user=mysql --console
else
	echo "Database already initialized. Starting normally..."
	exec mysqld --user=mysql --console
fi
