ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-apache
    
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD preview.html /var/preview/index.html

RUN composer config --global process-timeout 6000

ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD httpd.conf /usr/local/apache2/conf/httpd.conf.bk
RUN sed -i "s#{SERVER_ROOT}#/var/preview#g" /usr/local/apache2/conf/httpd.conf
RUN sed -i "s#{SERVER_ROOT}#/var/www/public#g" /usr/local/apache2/conf/httpd.conf.bk

ADD php.ini /etc/php${PHP_VERSION}/php.ini

ARG DISPLAY_PHPERROR
RUN if [ ${DISPLAY_PHPERROR} = true ]; \
    then \
        sed -i "s#{DISPLAY}#On#g" /etc/php${PHP_VERSION}/php.ini \
    ;else \
        sed -i "s#{DISPLAY}#Off#g" /etc/php${PHP_VERSION}/php.ini \
    ;fi

#Xdebug enable or disable
ARG XDEBUG
RUN if [ ${XDEBUG} = true ]; \
    then \
    apk add php${PHP_VERSION}-pecl-xdebug \
        && echo "[xdebug]" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "zend_extension = xdebug" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "xdebug.mode = debug" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "xdebug.remote_autostart = 0" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "xdebug.remote_enable = 1" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "xdebug.log_level = 0" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "xdebug.discover_client_host = 1" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "xdebug.client_host = host.docker.internal" >> /etc/php${PHP_VERSION}/php.ini \
        && echo "xdebug.start_with_request = yes" >> /etc/php${PHP_VERSION}/php.ini \
    ;fi

ARG INSTALL_ADDITIONAL_EXTENSIONS
RUN for ext in $(echo ${INSTALL_ADDITIONAL_EXTENSIONS} | tr ',' ' '); do \
        apk add --no-cache php${PHP_VERSION}-$ext || echo "Skipping $ext"; \
    done
RUN if echo ",${INSTALL_ADDITIONAL_EXTENSIONS}," | grep -q ",pdo_mysql,"; then \
        apk add --no-cache mysql-client \
    fi
    
ARG LARAVEL_VERSION
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i "s#{LARAVEL_VERSION}#${LARAVEL_VERSION}#g" /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

WORKDIR /var/www/localhost/htdocs

EXPOSE 80
CMD ["/docker-entrypoint.sh", "&", "apache2-foreground"]