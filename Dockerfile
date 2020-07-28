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
          util-linux \
          vim \
          systemd \
          nfs-common \
          net-tools \
          snmp \
          rpcbind \
          musl \
          openrc \
          composer \
          wget \
          nginx \
          npm

# install other stuff
RUN npm init --yes
RUN npm install -g npm@latest
RUN npm install -g n
RUN n latest
RUN npm install -g yarn
RUN npm install -g bowser
##
# RUN mkdir /var/www # made by nginx
RUN chown www-data:www-data /var/www
RUN usermod -s /bin/bash www-data

WORKDIR /var/www

RUN rm -rf /var/www/*
RUN runuser -l www-data -c 'git clone --single-branch --branch 9.0.x https://github.com/drupal/recommended-project.git .'
RUN runuser -l www-data -c 'composer update'
RUN runuser -l www-data -c 'composer require drush/drush'
RUN runuser -l www-data -c 'composer require civicrm/civicrm-asset-plugin civicrm/civicrm-drupal-8 civicrm/civicrm-packages'
RUN runuser -l www-data -c 'composer require "drupal/bfd:^2.54"'
RUN runuser -l www-data -c 'git clone https://github.com/thelounge/thelounge'

WORKDIR /var/www/thelounge

# Expose HTTP.
ENV PORT 9000
EXPOSE ${PORT}

RUN yarn install
RUN NODE_ENV=production yarn build
RUN yarn link
RUN thelounge start &

WORKDIR /var/www

# loop de loop to keep going
CMD tail -f /dev/null
