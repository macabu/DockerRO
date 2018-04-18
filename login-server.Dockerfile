FROM alpine:edge

RUN apk --update add --no-cache build-base mariadb-dev pcre-dev zlib-dev

COPY 3rdparty /login-server/3rdparty
COPY conf /login-server/conf
COPY src /login-server/src
COPY configure /login-server/configure
COPY configure.in /login-server/configure.in
COPY Makefile.in /login-server/Makefile.in

WORKDIR /login-server

RUN ./configure
RUN make clean && make login

RUN mv conf/import-tmpl conf/import

RUN ./login-server
