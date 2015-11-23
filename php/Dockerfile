FROM php:5.6-fpm

# Install sybase-ct extension
RUN apt-get update && apt-get install -y \
        freetds-common \
        freetds-bin \
        freetds-dev \
        unixodbc \
    && docker-php-ext-configure sybase_ct --with-sybase-ct=shared,/usr \
    && docker-php-ext-install sybase_ct
