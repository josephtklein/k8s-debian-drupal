# STAGE 1: Build
FROM debian:stable-slim AS build

ENV COMPOSER_MEMORY_LIMIT=-1
# Install Stuff
RUN     apt-get update && \
        apt-get -y upgrade && \
        apt-get -y install  \
          bash \
          git \
          php8.1 \
          php8.1-fpm \
          php8.1-dom \
          php8.1-gd \
          php8.1-pdo \
          php8.1-simplexml \
          php8.1-tokenizer \
          php8.1-xml \
          php8.1-curl \
          php8.1-xmlwriter \
          php8.1-json \
          php8.1-ctype \
          php8.1-posix \
          php8.1-soap \
          php8.1-intl \
          php8.1-bz2 \
          php8.1-mysql \
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
RUN runuser -l www-data -c 'composer require "drupal/qwebirc:^1.0"'
#RUN runuser -l www-data -c 'git clone https://github.com/thelounge/thelounge'

#WORKDIR /var/www/thelounge

## Expose HTTP.
#ENV LOUNGE_PORT 9000
#EXPOSE ${LOUNGE_PORT}

#RUN yarn install
#RUN NODE_ENV=production yarn build
#RUN yarn link
##RUN `yarn link "thelounge"`
#RUN thelounge start &

#WORKDIR /var/www

# Expose HTTP.
ENV PORT 80
EXPOSE ${PORT}
# Expose HTTPS.
ENV HTTPS_PORT 443
EXPOSE ${HTTPS_PORT}

# need nginx config.
#

# loop de loop to keep going
CMD tail -f /dev/null
