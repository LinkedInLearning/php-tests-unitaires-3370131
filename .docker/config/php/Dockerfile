# See https://github.com/docker-library/php/blob/master/7.1/fpm/Dockerfile
FROM devilbox/php-fpm:8.2-work
ARG TIMEZONE

MAINTAINER Julian LAYEN <layenjulian@gmail.com>

RUN apt-get update && apt-get install -y \
    openssl \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer self-update --2
RUN composer --version

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini
RUN "date"

# Type docker-php-ext-install to see available extensions
# RUN docker-php-ext-install pdo pdo_mysql

RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

# install yarn
RUN apt-get update && apt-get install -y apt-transport-https gnupg gnupg1 gnupg2
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install -y nodejs

WORKDIR /var/www/html