FROM php:8.4-apache

EXPOSE 2010

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

# Create folders, install dependencies and extensions
RUN mkdir -p /app /tools && \
    apt update && \
    apt install -y wget && \
    wget -O /tools/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /tools/install-php-extensions && \
    /tools/install-php-extensions gettext mbstring curl zip xml gd intl && \
    a2enmod rewrite

# Download and extract Gibbon to /app
RUN wget -O /tmp/gibbon.tar.gz https://github.com/GibbonEdu/core/releases/download/v29.0.00/GibbonEduCore-InstallBundle.tar.gz && \
    tar -xzf /tmp/gibbon.tar.gz -C /app --strip-components=1 && \
    rm /tmp/gibbon.tar.gz

# Copy config
COPY config/ /config
RUN cp /config/vhost.conf /etc/apache2/sites-available/000-default.conf && \
    cp /config/apache.conf /etc/apache2/conf-available/z-app.conf && \
    a2enconf z-app

# Add PHP config
RUN cp /config/php.ini /usr/local/etc/php/conf.d/app.ini

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["apache2-foreground"]