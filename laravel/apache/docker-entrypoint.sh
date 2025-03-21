#!/bin/bash
set +x
if [[ $(curl -Is https://laravel.com | head -n 1 | cut -d ' ' -f 2 ) == "200" ]]; then
if [[ -f "/var/www/composer.json" ]] ;
then
    cd /var/www/
    if [[ -d "/var/www/vendor" ]] ;
    then
        # echo "Steps to use Composer optimise autoloader"
        # sudo composer update --prefer-dist --no-interaction --optimize-autoloader --no-dev
        echo "Steps to Clear All Development inputs"
        sudo php artisan view:clear
        sudo php artisan route:clear
        sudo php artisan config:clear
        sudo php artisan clear-compiled
    else
        echo "If composer vendor folder is not installed follow the below steps"
        sudo composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev
    fi

fi
if [[ "$(ls -A "/var/www/")" ]] ;
    then
        echo "If the Directory is not empty, please delete the hidden files and directory"
    else
        sudo composer config --global process-timeout 6000
        sudo composer create-project --prefer-dist laravel/laravel:^{LARAVEL_VERSION}.0 .
        if [ $? != 0 ]; then
        sh /docker-entrypoint.sh 
        fi
fi
echo "Steps to check application environment variable"
if [[ ! -f ".env" ]] ;
then
    echo ".env file not found"
    sudo cp .env.example .env
else
    echo ".env file exit"
fi

sudo cp /app/httpd.conf /etc/apache2/httpd.conf
httpd -k graceful
sudo chown -R apache:apache /var/www 2> /dev/null
rm -rf /var/preview 2> /dev/null

sudo php artisan key:generate

exec "$@"

else
    echo "Internet not working check your Internet connection or network";
fi