FROM php:8.3-cli

# Install dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader

# Create Laravel folders
RUN mkdir -p \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    bootstrap/cache \
    storage/oauth

# Fix permissions
RUN chmod -R 777 storage bootstrap/cache

# Clear caches
RUN php artisan config:clear || true

EXPOSE 8080

CMD php -S 0.0.0.0:$PORT -t public
