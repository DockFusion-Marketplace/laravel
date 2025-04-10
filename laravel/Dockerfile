ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-apache
    
RUN apt-get update

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer config --global process-timeout 6000

# Install necessary PHP extensions (for Laravel)
RUN apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    zip \
    git
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql mbstring bcmath zip 

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

ADD 000-default.main.conf /etc/apache2/sites-available/000-default.conf.bk
ADD 000-default.preview.conf /etc/apache2/sites-available/000-default.conf

#Xdebug enable or disable
ARG XDEBUG
RUN if [ ${XDEBUG} = true ]; \
    then \
        pecl install xdebug; \
        docker-php-ext-enable xdebug; \
        echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name 'xdebug.so' | head -n 1)" > /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini; \
    fi

ARG INSTALL_ADDITIONAL_EXTENSIONS
RUN for ext in $(echo ${INSTALL_ADDITIONAL_EXTENSIONS} | tr ',' ' '); do \
        echo $ext; \
        apt-get install -y php${PHP_VERSION}-$ext || echo "Skipping $ext"; \
    done
RUN if echo ",${INSTALL_ADDITIONAL_EXTENSIONS}," | grep -q ",pdo_mysql,"; \
    then \
        apt-get install -y default-mysql-client; \
    fi
    
ARG LARAVEL_VERSION
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i "s#{LARAVEL_VERSION}#${LARAVEL_VERSION}#g" /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ARG DISPLAY_PHPERROR
RUN if [ ${DISPLAY_PHPERROR} = true ]; \
    then \
        echo "display_errors=On" >> /usr/local/etc/php/conf.d/php.ini; \
    else \
        echo "display_errors=Off" >> /usr/local/etc/php/conf.d/php.ini; \
    fi

# Clear apt-get cache
RUN rm -rf /var/lib/apt/lists/*;

ADD preview.html /var/www/preview/index.html

WORKDIR /var/www/html

EXPOSE 80
CMD ["/docker-entrypoint.sh", "apache2-foreground"]