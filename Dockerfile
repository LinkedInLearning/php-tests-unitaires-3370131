FROM php:8.2-apache

# Installation des extensions PHP et autres outils requis
RUN apt-get update && apt-get install -y libicu-dev zip unzip git \\
    && docker-php-ext-install intl pdo pdo_mysql opcache

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuration d'Apache
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite