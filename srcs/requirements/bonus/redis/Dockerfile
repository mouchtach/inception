FROM debian:bullseye

RUN apt update && apt install -y redis-server && rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf
COPY tools/start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]