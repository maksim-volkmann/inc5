#!/bin/bash
set -e

# Create directory for MariaDB runtime files
mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Load secrets
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASS=$(cat /run/secrets/db_pass)
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)

# Check if MariaDB already initialized
if [ -f /var/lib/mysql/.initialized ]; then
	echo "Database already initialized. Skipping setup."
	exec mysqld --user=mysql --console
fi

# Start MariaDB in the background without networking
mysqld --user=mysql --skip-networking &
pid=$!

# Wait for MariaDB to become ready
echo "Waiting for MariaDB to start..."
while ! mysqladmin ping --silent; do
	sleep 1
done

echo "MariaDB started. Running initialization..."

# Initialize database, user, and root password
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_ROOT_PASS}');
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Initialization complete."

# Mark that initialization has been done
touch /var/lib/mysql/.initialized

# Stop the temporary MariaDB instance
mysqladmin -u root -p${DB_ROOT_PASS} shutdown

# Start MariaDB in the foreground
exec mysqld --user=mysql --console
