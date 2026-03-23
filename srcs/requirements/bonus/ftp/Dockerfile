FROM debian:bullseye

RUN apt update && apt install -y --no-install-recommends \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf

RUN touch /etc/vsftpd.userlist

COPY tools/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 21 30000-30009

ENTRYPOINT ["/start.sh"]