FROM php:8.2-fpm

# ដំឡើង dependencies របស់ប្រព័ន្ធ និងកម្មវិធីបន្ថែម (Extension) សម្រាប់ PostgreSQL និង Laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpq-dev \
    libonig-dev \
    zip \
    unzip \
    --no-install-recommends && \
    docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd sockets && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ដំឡើង Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# កំណត់ទីតាំងធ្វើការ
WORKDIR /var/www/html

# ចម្លងឯកសារកម្មវិធីទាំងអស់ចូលក្នុង Container
COPY . /var/www/html

# កែសម្រួល Permissions សម្រាប់ storage និង cache
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage

# កំណត់ Port 9000 សម្រាប់ PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]