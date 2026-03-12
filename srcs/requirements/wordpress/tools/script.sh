#!/bin/bash

set -eu

read_secret() {
    local secret_path="$1"

    if [ -f "$secret_path" ]; then
        tr -d '\r' < "$secret_path" | sed 's/[[:space:]]*$//'
    fi
}

DB_NAME_VALUE="${DB_NAME:-wordpress}"
DB_USER_VALUE="${DB_USER:-wp_user}"
DB_HOST_VALUE="${DB_HOST:-mariadb}"
DB_PASSWORD_VALUE="${DB_PASSWORD:-$(read_secret /run/secrets/db_password)}"

mkdir -p /var/www/html /run/php
cd /var/www/html

if [ ! -f index.php ]; then
    wp core download --allow-root
fi

rm -f wp-config.php
wp config create \
    --dbname="$DB_NAME_VALUE" \
    --dbuser="$DB_USER_VALUE" \
    --dbpass="$DB_PASSWORD_VALUE" \
    --dbhost="$DB_HOST_VALUE" \
    --skip-check \
    --allow-root

until mysqladmin ping -h"$DB_HOST_VALUE" -u"$DB_USER_VALUE" -p"$DB_PASSWORD_VALUE" --silent; do
    echo "Waiting for database..."
    sleep 2
done

if ! wp core is-installed --allow-root; then
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USR" \
        --admin_password="$(cat /run/secrets/wp_password)" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
fi

if [ -n "${WP_USR:-}" ] && [ -n "${WP_EMAIL:-}" ] && [ -n "${WP_PWD:-}" ]; then
    if ! wp user get "$WP_USR" --field=user_login --allow-root >/dev/null 2>&1; then
        wp user create "$WP_USR" "$WP_EMAIL" \
            --role=author \
            --user_pass="$(cat /run/secrets/wp_admin_password)" \
            --allow-root
    fi
fi

PHP_FPM_CONF="$(find /etc/php -path '*/fpm/pool.d/www.conf' | head -n 1)"
PHP_FPM_BIN="$(command -v php-fpm || command -v php-fpm7.4)"

sed -i 's|^listen = .*|listen = 9000|' "$PHP_FPM_CONF"
chown -R www-data:www-data /var/www/html

exec "$PHP_FPM_BIN" -F