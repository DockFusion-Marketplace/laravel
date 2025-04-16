ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-apache

RUN apt-get update

# Add all necessary files
ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD 000-default.main.conf /etc/apache2/sites-available/000-default.conf.bk
ADD 000-default.preview.conf /etc/apache2/sites-available/000-default.conf
ADD preview.html /var/www/preview/index.html
RUN chmod +x /docker-entrypoint.sh

# Setup laravel version to be installed on first run with empty folder (new project)
ARG LARAVEL_VERSION
RUN sed -i "s#{LARAVEL_VERSION}#${LARAVEL_VERSION}#g" /docker-entrypoint.sh

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer config --global process-timeout 6000

# Install NVM
ARG NVM_VERSION=v0.40.2
ENV NVM_DIR=/root/.nvm
RUN curl -sS https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Install NODE
ARG NODE_VERSION=--lts
RUN bash -c "source ${NVM_DIR}/nvm.sh && nvm install ${NODE_VERSION} && npm install -g yarn"

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
RUN docker-php-ext-install gd pdo mbstring bcmath zip 

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Install and configure Xdebug
ARG XDEBUG
RUN if [ ${XDEBUG} = true ]; \
    then \
        pecl install xdebug; \
        docker-php-ext-enable xdebug; \
        echo "" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.log_level=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    fi

# Enable or disable php errors
ARG DISPLAY_PHPERROR
RUN if [ ${DISPLAY_PHPERROR} = true ]; \
    then \
        echo "display_errors=On" >> /usr/local/etc/php/conf.d/php.ini; \
    else \
        echo "display_errors=Off" >> /usr/local/etc/php/conf.d/php.ini; \
    fi

# Install additional extensions
ARG INSTALL_ADDITIONAL_EXTENSIONS
RUN for ext in $(echo ${INSTALL_ADDITIONAL_EXTENSIONS} | tr ',' ' '); do \
        echo $ext; \
        docker-php-ext-install $ext || echo "Skipping $ext"; \
    done

# Install mysql client if app uses pdo_mysql
RUN if echo ",${INSTALL_ADDITIONAL_EXTENSIONS}," | grep -q ",pdo_mysql,"; \
    then \
        apt-get install -y default-mysql-client; \
    fi

# Clear apt-get cache
RUN rm -rf /var/lib/apt/lists/*;

# https://xdebug.org/docs/all_settings#idekey
ENV DBGP_IDEKEY=VSC
# https://xdebug.org/docs/all_settings#mode
ENV XDEBUG_MODE=develop,debug

# Exit
WORKDIR /var/www/html
EXPOSE 80
CMD ["/docker-entrypoint.sh", "apache2-foreground"]