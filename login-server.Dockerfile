FROM alpine:edge

ARG MYSQL_USER
ARG MYSQL_DATABASE
ARG MYSQL_PASSWORD

RUN apk --update add --no-cache build-base mariadb-dev pcre-dev zlib-dev

COPY 3rdparty /login-server/3rdparty
COPY conf /login-server/conf
COPY src/custom /login-server/src/custom
COPY src/config /login-server/src/config
COPY src/login /login-server/src/login
COPY src/common /login-server/src/common
COPY src/char/Makefile.in /login-server/src/char/Makefile.in
COPY src/map/Makefile.in /login-server/src/map/Makefile.in
COPY src/tool/Makefile.in /login-server/src/tool/Makefile.in
COPY configure /login-server/configure
COPY configure.in /login-server/configure.in
COPY Makefile.in /login-server/Makefile.in

WORKDIR /login-server

RUN ./configure
RUN make login

RUN mv conf/import-tmpl conf/import

RUN echo 'bind_ip: login-server' >> conf/import/login_conf.txt

RUN echo $'login_server_ip: db\n\
login_server_port: 3306\n\
login_server_id: '$MYSQL_USER''$'\n\
login_server_pw: '$MYSQL_PASSWORD''$'\n\
login_server_db: '$MYSQL_DATABASE''$'\n\
ipban_db_ip: db\n\
ipban_db_port: 3306\n\
ipban_db_id: '$MYSQL_USER''$'\n\
ipban_db_pw: '$MYSQL_PASSWORD''$'\n\
ipban_db_db: '$MYSQL_DATABASE''$'\n\
char_server_ip: db\n\
char_server_port: 3306\n\
char_server_id: '$MYSQL_USER''$'\n\
char_server_pw: '$MYSQL_PASSWORD''$'\n\
char_server_db: '$MYSQL_DATABASE''$'\n\
map_server_ip: db\n\
map_server_port: 3306\n\
map_server_id: '$MYSQL_USER''$'\n\
map_server_pw: '$MYSQL_PASSWORD''$'\n\
map_server_db: '$MYSQL_DATABASE''$'\n\
log_db_ip: db\n\
log_db_port: 3306\n\
log_db_id: '$MYSQL_USER''$'\n\
log_db_pw: '$MYSQL_PASSWORD''$'\n\
log_db_db: '$MYSQL_DATABASE''\
>> conf/import/inter_conf.txt

CMD ["/login-server/login-server"]
