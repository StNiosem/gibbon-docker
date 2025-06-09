# PHP
FROM php:8.4-apache

# Install GetText, MBString, Curl, Zip, XML, GD and intl extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extenstions gettext mbstring curl zip xml gd intl

# Enable Apache mod_rewrite
RUN a2enmod rewrite


