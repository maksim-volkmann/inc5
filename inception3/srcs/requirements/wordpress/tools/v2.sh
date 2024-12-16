#!/bin/bash
set -e

cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# SECRETS
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASS=$(cat /run/secrets/db_pass)
ADMIN_USER=$(cat /run/secrets/admin_user)
ADMIN_PASS=$(cat /run/secrets/admin_pass)
ADMIN_EMAIL=$(cat /run/secrets/admin_email)
REGULAR_USER=$(cat /run/secrets/regular_user)
REGULAR_PASS=$(cat /run/secrets/regular_pass)
REGULAR_EMAIL=$(cat /run/secrets/regular_email)

DOMAIN_NAME=${DOMAIN_NAME}

# Check if WordPress is already installed (if wp-config.php exists)
if [ ! -f "wp-config.php" ]; then
    echo "WordPress not found. Installing...aa"
    ./wp-cli.phar core download --allow-root
    ./wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=mariadb --allow-root
	# ./wp-cli.phar config create --dbname=wordpress --dbuser=mvolkman --dbpass=askrabas1122E# --dbhost=mariadb --allow-root
    ./wp-cli.phar core install --url="https://$DOMAIN_NAME" --title=inception --admin_user=${ADMIN_USER} --admin_password=${ADMIN_PASS} --admin_email=${ADMIN_EMAIL} --allow-root
	./wp-cli.phar user create $REGULAR_USER $REGULAR_EMAIL --role=subscriber --user_pass=$REGULAR_PASS --allow-root
    ./wp-cli.phar option update siteurl "https://$DOMAIN_NAME" --allow-root
    ./wp-cli.phar option update home "https://$DOMAIN_NAME" --allow-root

    # Explicitly create wp-content/uploads and set permissions
    mkdir -p wp-content/uploads
    chmod -R 0777 wp-content/uploads

	# Ensure wp-content directory is writable
	# Redis to be writable.
	chown -R www-data:www-data /var/www/html/wp-content
	chmod -R 775 /var/www/html/wp-content

	# Add Redis configuration
	./wp-cli.phar config set WP_REDIS_HOST redis --allow-root
	./wp-cli.phar config set WP_REDIS_PORT 6379 --raw --allow-root
	./wp-cli.phar config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
	./wp-cli.phar config set WP_REDIS_CLIENT phpredis --allow-root
	./wp-cli.phar plugin install redis-cache --activate --allow-root
	./wp-cli.phar plugin update --all --allow-root
	./wp-cli.phar redis enable --allow-root


	# Let upload files via admin panel. (also for redis)
	./wp-cli.phar config set FS_METHOD direct --allow-root

    echo "WordPress installation complete."
else
    echo "WordPress already configured, skipping installation."
fi





# Start PHP-FPM
php-fpm8.2 -F
