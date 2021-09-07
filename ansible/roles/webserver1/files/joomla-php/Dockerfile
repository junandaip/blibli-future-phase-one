FROM alpine:3.14

# Timezone
ENV TIMEZONE="Asia/Jakarta"

# Install PHP and the necessary modules for Joomla!
RUN apk -U --no-cache add \
    bash \    
    php7 \
    php7-cli \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-gd \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-memcached \
    php7-mysqli \
    php7-opcache \
    php7-pgsql \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-simplexml \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-xmlrpc \
    php7-zip \
    rsync \
    curl && \
    rm -fr /var/cache/apk/*

# Timezone setting for the system
RUN apk -U --no-cache add tzdata && \
    # Specify the timezone in /etc/localtime
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    # Use the specified timezone for current machine
    echo "${TIMEZONE}" > /etc/timezone && \
    # You can delete the other timezone
    apk del tzdata

# Add www user and setup root folder
# 82 is the standard uid/gid for "www-data" in Alpine
RUN adduser -u 1000 -D -S -G www-data www-data && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Set the recommended PHP settings for Joomla!
RUN sed -i -e "s/memory_limit = .*/memory_limit = 256M/" \     
    -e "s/upload_max_filesize = .*/upload_max_filesize = 128M/" \
    -e "s/post_max_size = .*/post_max_size = 128M/" \
    -e "s/output_buffering = .*/output_buffering = Off/" \
    -e "s/max_execution_time = .*/max_execution_time = 30/" \
    -e "s/;date.timezone.*/date.timezone = Asia\/Jakarta/" \
    -e "s/display_errors = .*/display_errors = On/" \
    /etc/php7/php.ini && \
    # Set the PHP-FPM settings
    sed -i -e "s/;daemonize = .*/daemonize = no/" \
    /etc/php7/php-fpm.conf && \
    sed -i -e "s/listen = .*/listen = 0.0.0.0:9000/" \
    -e "s/user = .*/user = www-data/" \
    -e "s/group = .*/group = www-data/" \
    /etc/php7/php-fpm.d/www.conf

# Install Joomla!
ENV JOOMLA_VERSION=3.10.0

RUN curl -# -o joomla.zip -SL https://github.com/joomla/joomla-cms/releases/download/${JOOMLA_VERSION}/Joomla_${JOOMLA_VERSION}-Stable-Full_Package.zip && \
    mkdir -p /usr/src/joomla && \
    unzip joomla.zip -d /usr/src/joomla && \ 
    rm joomla.zip && \
    chown -R www-data:www-data /usr/src/joomla

WORKDIR /var/www/html

EXPOSE 9000

COPY docker-entrypoint.sh /entrypoint.sh
COPY configuration.php /configuration.php

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/php-fpm7"]
