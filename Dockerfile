FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# 1. Pehle poora code container ke andar copy karein
COPY . /var/www/html

# 2. Yeh sabse mukhya line hai: Docker khud-b-khud dependencies install kar lega!
RUN composer install --no-dev --optimize-autoloader

# 3. Storage folders ko permissions dein
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 4. Server start karne ki command
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]