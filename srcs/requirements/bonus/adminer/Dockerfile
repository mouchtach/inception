FROM debian:bullseye


RUN apt -y update 

COPY ./tools/script.sh /

RUN chmod +x /script.sh

RUN apt install wget -y && apt install php php-mysql  -y

EXPOSE 8080

CMD [ "/script.sh" ]