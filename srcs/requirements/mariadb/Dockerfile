FROM debian:bullseye

RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./conf/99-inception.cnf /etc/mysql/mariadb.conf.d/99-inception.cnf

COPY ./tools/script.sh /

RUN chmod +x /script.sh

CMD ["/script.sh"]