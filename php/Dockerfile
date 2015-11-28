FROM php:5.6-fpm

# Install sybase-ct extension
RUN apt-get update && apt-get install -y \
        freetds-common \
        freetds-bin \
        freetds-dev \
        tdsodbc \
        libiodbc2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install sybase_ct extension
RUN docker-php-ext-configure sybase_ct --with-sybase-ct=shared,/usr \
    && docker-php-ext-install sybase_ct

# Install obdc extension
# Regular method does not seem to work -> https://github.com/docker-library/php/issues/103
RUN set -x \
    && cd /usr/src/php/ext/odbc \
    && phpize \
    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
    && ./configure --with-iodbc=shared,/usr \
    && docker-php-ext-install odbc

# Link odbc configuration files to the definitive paths
RUN rm -f /etc/odbcinst.ini /etc/odbc.ini
RUN ln -s /etc/odbc/odbcinst.ini /etc/odbcinst.ini
RUN ln -s /etc/odbc/odbc.ini /etc/odbc.ini
