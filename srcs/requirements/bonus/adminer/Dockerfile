FROM debian:bullseye

RUN apt -y update && apt install wget -y && apt install php php-mysql  -y

COPY ./tools/script.sh /

RUN chmod +x /script.sh

EXPOSE 8080

CMD [ "/script.sh" ]