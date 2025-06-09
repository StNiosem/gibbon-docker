# PHP
FROM php:8.4-apache

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN mkdir -p /app
RUN mkdir -p /tools

RUN apt update
RUN apt install wget -y
# Install GetText, MBString, Curl, Zip, XML, GD and intl extensions
RUN wget -O /tools/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions
RUN chmod +x /tools/install-php-extensions
RUN /tools/install-php-extensions gettext mbstring curl zip xml gd intl

# Enable Apache mod_rewrite
RUN a2enmod rewrite

RUN wget -O /tmp/gibbon.tar.gz https://github.com/GibbonEdu/core/releases/download/v29.0.00/GibbonEduCore-InstallBundle.tar.gz
RUN tar -xzf /tmp/gibbon.tar.gz -C /app