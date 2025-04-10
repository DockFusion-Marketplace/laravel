#!/bin/bash
set +x
cd /var/www/

if [[ ! "$(ls -A "/var/www/")" ]] ;
then
    composer create-project --prefer-dist laravel/laravel:^{LARAVEL_VERSION}.0 .
fi

if [[ -f "/var/www/composer.json" ]] ;
then
    if [[ ! -d "/var/www/vendor" ]] ;
    then
        composer install
    fi
fi

if [[ ! -f ".env" ]] ;
then
    echo ".env file not found"
    cp .env.example .env
    php artisan key:generate
fi

cp /usr/local/apache2/conf/httpd.conf.bk /usr/local/apache2/conf/httpd.conf
sudo chown -R apache:apache /var/www 2> /dev/null

exec "$@"