# Create a Wordpress development environment with PHP, Apache, and WP-CLI
# to be used in a devcontainer, together with Docker Desktop and Visual Studio Code.

FROM php:8.2-apache

# add deb packages used in the Docker Wordpress image
RUN apt-get update -y && apt-get upgrade -y &&\
  apt-get install -y --no-install-recommends \
  libavif-dev \
	libfreetype6-dev \
  libicu-dev \
  libjpeg-dev \
  libmagickwand-dev \
  libpng-dev \
  libwebp-dev \
  libzip-dev

# configure php extensions
RUN docker-php-ext-configure gd \
  --with-avif \
  --with-freetype \
  --with-jpeg \
  --with-webp

# install php extensions
RUN docker-php-ext-install -j "$(nproc)" \
  bcmath \
  exif \
  gd \
  intl \
  mysqli \
  zip

# install imagick
RUN pecl install imagick-3.7.0 &&\
  docker-php-ext-enable imagick &&\
  rm -r /tmp/pear

# add wp-cli
RUN \
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
  chmod +x wp-cli.phar &&\
  mv wp-cli.phar /usr/local/bin/wp

# set up the vhost to serve from /app/public_html for localhost
RUN mkdir -p /app/public_html

COPY .devcontainer/apache-vhost.conf /etc/apache2/sites-available/000-default.conf
