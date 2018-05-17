FROM alpine:edge

ARG MYSQL_USER
ARG MYSQL_DATABASE
ARG MYSQL_PASSWORD

RUN apk --update add --no-cache build-base mariadb-dev pcre-dev zlib-dev

COPY 3rdparty /char-server/3rdparty
COPY conf /char-server/conf
COPY db /char-server/db
COPY src /char-server/src
COPY configure /char-server/configure
COPY configure.in /char-server/configure.in
COPY Makefile.in /char-server/Makefile.in

WORKDIR /char-server

RUN ./configure
RUN make char

RUN mv conf/import-tmpl conf/import

RUN echo $'login_ip: login-server\n\
bind_ip: char-server\n\
char_ip: char-server'\
>> conf/import/char_conf.txt

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

CMD ["/char-server/char-server"]
