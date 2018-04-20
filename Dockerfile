FROM alpine:edge

RUN apk --update add --no-cache build-base mariadb-dev pcre-dev zlib-dev

COPY . /rathena

WORKDIR /rathena

RUN ./configure
RUN make clean && make server 

RUN mv conf/import-tmpl conf/import
