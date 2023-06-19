#!/bin/bash

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker

curl -SL https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod -x /usr/local/bin/docker-compose

[ ! -d /root/libre-nms ] && mkdir -p /root/libre-nms

cat << EOF-env > /root/libre-nms/.env
TZ=America/Chicago
PUID=1000
PGID=1000

MYSQL_DATABASE=librenms
MYSQL_USER=ninelibrenms
MYSQL_PASSWORD="ninepassword"
EOF-env

cat << EOF-libre > /root/libre-nms/librenms.env
MEMORY_LIMIT=256M
UPLOAD_MAX_SIZE=16M
OPCACHE_MEM_SIZE=128
REAL_IP_FROM=0.0.0.0/32
REAL_IP_HEADER=X-Forwarded-For
LOG_IP_VAR=remote_addr

LIBRENMS_SNMP_COMMUNITY=librenmsdocker
MEMCACHED_HOST=memcached
MEMCACHED_PORT=11211

LIBRENMS_WEATHERMAP=false
LIBRENMS_WEATHERMAP_SCHEDULE=*/5 * * * *
EOF-libre

cat << EOF-snmp > /root/libre-nms/msmtpd.env
# https://github.com/crazy-max/docker-msmtpd
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_TLS=on
SMTP_STARTTLS=on
SMTP_TLS_CHECKCERT=on
SMTP_AUTH=on
SMTP_USER=nineuser
SMTP_PASSWORD=ninepassword
SMTP_FROM=foo@gmail.com
EOF-snmp

cat << EOF-compose /root/libre-nms/docker-compose.yml
version: "3.5"

services:
  db:
    image: mariadb:10.5
    container_name: librenms_db
    command:
      - "mysqld"
      - "--innodb-file-per-table=1"
      - "--lower-case-table-names=0"
      - "--character-set-server=utf8mb4"
      - "--collation-server=utf8mb4_unicode_ci"
    volumes:
      - "./db:/var/lib/mysql"
    environment:
      - "TZ=${TZ}"
      - "MYSQL_ALLOW_EMPTY_PASSWORD=yes"
      - "MYSQL_DATABASE=${MYSQL_DATABASE}"
      - "MYSQL_USER=${MYSQL_USER}"
      - "MYSQL_PASSWORD=${MYSQL_PASSWORD}"
    restart: always

  memcached:
    image: memcached:alpine
    container_name: librenms_memcached
    environment:
      - "TZ=${TZ}"
    restart: always

  redis:
    image: redis:5.0-alpine
    container_name: librenms_redis
    environment:
      - "TZ=${TZ}"
    restart: always

  msmtpd:
    image: crazymax/msmtpd:latest
    container_name: librenms_msmtpd
    env_file:
      - "./msmtpd.env"
    restart: always

  librenms:
    image: librenms/librenms:latest
    container_name: librenms
    hostname: librenms
    cap_add:
      - NET_ADMIN
      - NET_RAW
    ports:
      - target: 8000
        published: 8000
        protocol: tcp
    depends_on:
      - db
      - memcached
      - msmtpd
    volumes:
      - "./librenms:/data"
#      - "./librenms/config/config.php:/opt/librenfs/config.php"
    env_file:
      - "./librenms.env"
    environment:
      - "TZ=${TZ}"
      - "PUID=${PUID}"
      - "PGID=${PGID}"
      - "DB_HOST=db"
      - "DB_NAME=${MYSQL_DATABASE}"
      - "DB_USER=${MYSQL_USER}"
      - "DB_PASSWORD=${MYSQL_PASSWORD}"
      - "DB_TIMEOUT=60"
      - "REDIS_HOST=redis"
      - "REDIS_PORT=6379"
      - "REDIS_DB=0"
    restart: always

  dispatcher:
    image: librenms/librenms:latest
    container_name: librenms_dispatcher
    hostname: librenms-dispatcher
    cap_add:
      - NET_ADMIN
      - NET_RAW
    depends_on:
      - librenms
      - redis
    volumes:
      - "./librenms:/data"
    env_file:
      - "./librenms.env"
    environment:
      - "TZ=${TZ}"
      - "PUID=${PUID}"
      - "PGID=${PGID}"
      - "DB_HOST=db"
      - "DB_NAME=${MYSQL_DATABASE}"
      - "DB_USER=${MYSQL_USER}"
      - "DB_PASSWORD=${MYSQL_PASSWORD}"
      - "DB_TIMEOUT=60"
      - "DISPATCHER_NODE_ID=dispatcher1"
      - "REDIS_HOST=redis"
      - "REDIS_PORT=6379"
      - "REDIS_DB=0"
      - "SIDECAR_DISPATCHER=1"
    restart: always

  syslogng:
    image: librenms/librenms:latest
    container_name: librenms_syslogng
    hostname: librenms-syslogng
    cap_add:
      - NET_ADMIN
      - NET_RAW
    depends_on:
      - librenms
    ports:
      - target: 514
        published: 514
        protocol: tcp
      - target: 514
        published: 514
        protocol: udp
    volumes:
      - "./librenms:/data"
    env_file:
      - "./librenms.env"
    environment:
      - "TZ=${TZ}"
      - "PUID=${PUID}"
      - "PGID=${PGID}"
      - "DB_HOST=db"
      - "DB_NAME=${MYSQL_DATABASE}"
      - "DB_USER=${MYSQL_USER}"
      - "DB_PASSWORD=${MYSQL_PASSWORD}"
      - "DB_TIMEOUT=60"
      - "REDIS_HOST=redis"
      - "REDIS_PORT=6379"
      - "REDIS_DB=0"
      - "SIDECAR_SYSLOGNG=1"
    restart: always
EOF-compose

chown -R root:root /root/libre-nms
chmod -R 550 /root/libre-nms

docker-compose up -d -f /root/libre-nms/docker-compose.yml