FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        mariadb-client \
        php \
        php-cli \
        php-curl \
        php-fpm \
        php-gd \
        php-mbstring \
        php-mysql \
        php-xml \
        php-zip \
        unzip \
    && curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp \
    && rm -rf /var/lib/apt/lists/*

COPY tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000

CMD ["/usr/local/bin/script.sh"]

