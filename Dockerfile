# === Stage 1: Frontend Asset Compilation (Vite) ===
FROM node:20-alpine AS node-builder
WORKDIR /app
COPY package*.json vite.config.js ./
# Copy resources folder where your JS/CSS lives
COPY resources/ ./resources/
RUN npm ci
# Compiles assets into public/build/
RUN npm run build 

# === Stage 2: Backend Dependency Isolation (Composer) ===
FROM php:8.3-fpm-alpine AS php-builder
RUN apk add --no-cache libpng-dev libjpeg-turbo-dev freetype-dev zip libzip-dev unzip git oniguruma-dev libxml2-dev $PHPIZE_DEPS
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip xml
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www
COPY . .
RUN composer install --no-dev --optimize-autoloader --no-interaction

# === Stage 3: Minimal Production Runtime ===
FROM php:8.3-fpm-alpine
RUN apk add --no-cache libpng libjpeg-turbo freetype libzip mariadb-client
RUN docker-php-ext-install pdo_mysql bcmath

WORKDIR /var/www

# 1. Copy backend code and vendor files from Stage 2
COPY --from=php-builder /var/www /var/www

# 2. Copy compiled assets from Stage 1 into the public build directory
COPY --from=node-builder /app/public/build /var/www/public/build

# Fix ownership and permissions for security
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

USER www-data
EXPOSE 9000
CMD ["php-fpm"]
