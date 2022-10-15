FROM existenz/webstack:8.1 AS base

RUN apk add --no-cache \
    argon2 \
    curl \
    icu \
    php81 \
    php81-common \
    php81-ctype \
    php81-curl  \
    php81-dom  \
    php81-fileinfo \
    php81-fpm \
    php81-gd \
    php81-iconv \
    php81-intl \
    php81-json \
    php81-mbstring \
    php81-opcache \
    php81-openssl \
    php81-pdo \
    php81-pdo_pgsql \
    php81-pgsql \
    php81-phar \
    php81-redis \
    php81-session \
    php81-simplexml \
    php81-sodium \
    php81-tokenizer \
    php81-xml \
    php81-xmlreader \
    php81-xmlwriter \
    php81-zip \
    php81-zlib \
    shadow

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY ./docker/ /
RUN ln /usr/bin/php81 /usr/bin/php

FROM base AS dev

ARG GROUPID

RUN groupmod -o -g ${GROUPID} php \
 && chown -R php:php /www

FROM base AS prod

COPY --chown=php:php . /www
RUN composer install --ansi \
 && chown -R php:php /www/vendor
