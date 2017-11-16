FROM php:7.0.25-fpm-alpine

# install packages
RUN apk update \
    && apk --no-cache add \
        autoconf make g++ libc-dev \
        libmcrypt-dev libmcrypt \
        icu-dev icu-libs \
        mariadb-dev mariadb-libs mysql-client \
        pcre-dev \
        curl \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} bcmath intl mcrypt pdo_mysql zip \
    && pecl install apcu \
    && pecl install xdebug \
    && docker-php-ext-enable apcu xdebug

# enable apcu
RUN echo apc.enable_cli=1 >> /usr/local/etc/php/conf.d/apcu.ini

# install yarn
RUN echo -e 'http://dl-cdn.alpinelinux.org/alpine/edge/main\nhttp://dl-cdn.alpinelinux.org/alpine/edge/community\nhttp://dl-cdn.alpinelinux.org/alpine/edge/testing' > /etc/apk/repositories
RUN apk add --no-cache nodejs=8.9.1-r0 yarn

# set mysql charcode
RUN echo -e "[client]\ndefault-character-set=utf8mb4" > /etc/my.cnf

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

#USER www-data
