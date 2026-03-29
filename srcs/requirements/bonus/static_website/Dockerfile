FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends nginx \
    && mkdir -p /var/www/static /run/nginx \
    && rm -rf /var/lib/apt/lists/*

COPY www/ /var/www/static/
COPY conf/nginx.conf /etc/nginx/conf.d/static.conf

EXPOSE 5000

CMD ["nginx", "-g", "daemon off;"]
