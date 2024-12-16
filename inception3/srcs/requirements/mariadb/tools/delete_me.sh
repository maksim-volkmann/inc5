#!/bin/bash
set -e

# Create directory for MariaDB
mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# SECRETS (if needed, adjust these as necessary)
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASS=$(cat /run/secrets/db_pass)
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)

# Check if MariaDB already installed
if [ -f /var/lib/mysql/.initialized ]; then
	echo "Database already initialized. Skipping setup."
	exec mysqld --user=mysql --console
fi

# Start MariaDB in the background
mysqld --user=mysql --skip-networking &
pid=$!

# Wait for MariaDB to start
echo "Waiting for MariaDB to start..."
while ! mysqladmin ping --silent; do
	sleep 1
done

echo "MariaDB started. Checking if database '${DB_NAME}' exists..."

# Check if the database exists and use the root password
if mysql -u root -p${DB_ROOT_PASS} -e "USE ${DB_NAME}"; then
	echo "Database '${DB_NAME}' already exists. Skipping initialization."
else
	echo "Database '${DB_NAME}' does not exist. Running initialization..."

# Create the database and user, and grant privileges using the root password
mysql -u root -p${DB_ROOT_PASS} <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_ROOT_PASS}');
FLUSH PRIVILEGES;
EOF
	echo "Database '${DB_NAME}' and user '${DB_USER}' created successfully."
fi

touch /var/lib/mysql/.initialized

# Stop the temporary MariaDB instance
mysqladmin -u root -p${DB_ROOT_PASS} shutdown

# Start MariaDB in foreground (to keep container running)
exec mysqld --user=mysql --console
