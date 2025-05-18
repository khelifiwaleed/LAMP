FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    git \
    curl \
    libzip-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        mysqli \
        zip \
        xml \
        curl \
        gd \
        intl \
        mbstring \
        simplexml \
        opcache

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add a non-root user for better security
RUN useradd -m -d /home/docker-user -s /bin/bash docker-user

# Set the working directory
WORKDIR /var/www/html

# Copy Composer files and install dependencies
COPY ../../../composer.json /var/www/html/
RUN composer install --no-scripts --no-interaction

# Ensure proper permissions
RUN mkdir -p /var/www/html/vendor \
    && chown -R docker-user:docker-user /var/www/html \
    && chmod -R 777 /var/www/html/vendor

# Switch to the non-root user
USER docker-user

# Copy the remaining project files
COPY ../../.. /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

CMD ["php-fpm"]
