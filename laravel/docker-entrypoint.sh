#!/bin/bash
set +x
cd /var/www/html/

if [[ ! "$(ls -A "/var/www/html/")" ]] ;
then
    composer create-project --prefer-dist laravel/laravel:^{LARAVEL_VERSION}.0 .
fi

if [[ -f "/var/www/html/composer.json" ]] ;
then
    if [[ ! -d "/var/www/html/vendor" ]] ;
    then
        composer install
    fi
fi

if [[ ! -f "/var/www/html/.env" ]] ;
then
    echo ".env file not found"
    if [[ -f "/var/www/html/.env.example" ]] ;
    then
        cp /var/www/html/.env.example /var/www/html/.env
        php artisan key:generate
    else
        echo ".env.example file not found"
    fi
fi

cp /etc/apache2/sites-available/000-default.conf.bk /etc/apache2/sites-available/000-default.conf
mkdir -p /var/www/html/storage
mkdir -p /var/www/html/bootstrap/cache
chown -R www-data:www-data /var/www/html /var/www/html/storage /var/www/html/bootstrap/cache 2> /dev/null
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache 2> /dev/null

exec "$@"