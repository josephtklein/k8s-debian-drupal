# STAGE 1: Build
FROM debian:stable-slim AS build

ENV COMPOSER_MEMORY_LIMIT=-1
# Install Stuff
RUN     apt-get update && \
        apt-get upgrade && \
        apt-get -y install  \
                bash \
                git \
                php7.3 \
		php7.3-fpm \
                php7.3-dom \
                php7.3-gd \
                php7.3-pdo \
                php7.3-simplexml \
                php7.3-tokenizer \
                php7.3-xml \
                php7.3-curl \
                php7.3-xmlwriter \
                php7.3-json \
		php7.3-ctype \
		php7.3-posix \
		php7.3-soap \
		php7.3-intl \
		php7.3-bz2 \
		php7.3-mysql \
		net-tools \
		snmp \
		rpcbind \
		musl \
		openrc \
                composer \
                wget \
		npm


RUN npm init --yes
RUN npm install -g yarn
## Get dependencies for Go part of build
#RUN go get -u github.com/jteeuwen/go-bindata/...
#RUN go get github.com/tools/godep
RUN mkdir /var/www

WORKDIR /var/www

RUN rm -rf /var/www/*
RUN git clone --single-branch --branch 9.0.x https://github.com/drupal/recommended-project.git .
RUN composer update
RUN composer require drush/drush
RUN composer require 'drupal/bfd:^2.54'
RUN git clone https://github.com/thelounge/thelounge

WORKDIR /var/www/thelounge

RUN yarn install
RUN NODE_ENV=production yarn build
RUN yarn link
RUN thelounge start &

WORKDIR /var/www

# loop de loop to keep going
CMD tail -f /dev/null
