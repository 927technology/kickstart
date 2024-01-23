#!/bin/bash

#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

#install libre-nms
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/libre-nms.txt

#add librenms user
useradd -d /home/librenms -s /bin/bash -m librenms -u 1000

mkdir -p /etc/libre-nms

#persistent file paths
#mkdir -p /vol/var/lib/mysql
#mkdir -p /vol/data
mkdir -p /vol
chmod 755 /vol

cat << EOF-env > /etc/libre-nms/.env
TZ=America/Chicago
PUID=1000
PGID=1000

MYSQL_DATABASE=librenms
MYSQL_USER=librenms
MYSQL_PASSWORD=asupersecretpassword
EOF-env

cat << EOF-libre > /etc/libre-nms/librenms.env
MEMORY_LIMIT=256M
MAX_INPUT_VARS=1000
UPLOAD_MAX_SIZE=16M
OPCACHE_MEM_SIZE=128
REAL_IP_FROM=0.0.0.0/32
REAL_IP_HEADER=X-Forwarded-For
LOG_IP_VAR=remote_addr

CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=redis

LIBRENMS_SNMP_COMMUNITY=librenmsdocker

LIBRENMS_WEATHERMAP=false
LIBRENMS_WEATHERMAP_SCHEDULE=*/5 * * * *
EOF-libre

cat << EOF-snmp > /etc/libre-nms/msmtpd.env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_TLS=on
SMTP_STARTTLS=on
SMTP_TLS_CHECKCERT=on
SMTP_AUTH=on
SMTP_USER=foo
SMTP_PASSWORD=bar
SMTP_FROM=foo@gmail.com
EOF-snmp


cat << EOF-compose > /etc/libre-nms/docker-compose.yml
name: librenms

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
      - "/vol/var/lib/mysql:/var/lib/mysql"
    environment:
      - "TZ=\${TZ}"
      - "MYSQL_ALLOW_EMPTY_PASSWORD=yes"
      - "MYSQL_DATABASE=\${MYSQL_DATABASE}"
      - "MYSQL_USER=\${MYSQL_USER}"
      - "MYSQL_PASSWORD=\${MYSQL_PASSWORD}"
    restart: always

  redis:
    image: redis:5.0-alpine
    container_name: librenms_redis
    environment:
      - "TZ=\${TZ}"
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
      - redis
      - msmtpd
    volumes:
      - "/vol/data:/data"
    env_file:
      - "./librenms.env"
    environment:
      - "TZ=\${TZ}"
      - "PUID=\${PUID}"
      - "PGID=\${PGID}"
      - "DB_HOST=db"
      - "DB_NAME=\${MYSQL_DATABASE}"
      - "DB_USER=\${MYSQL_USER}"
      - "DB_PASSWORD=\${MYSQL_PASSWORD}"
      - "DB_TIMEOUT=60"
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
      - "/vol/data:/data"
    env_file:
      - "./librenms.env"
    environment:
      - "TZ=\${TZ}"
      - "PUID=\${PUID}"
      - "PGID=\${PGID}"
      - "DB_HOST=db"
      - "DB_NAME=\${MYSQL_DATABASE}"
      - "DB_USER=\${MYSQL_USER}"
      - "DB_PASSWORD=\${MYSQL_PASSWORD}"
      - "DB_TIMEOUT=60"
      - "DISPATCHER_NODE_ID=dispatcher1"
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
      - redis
    ports:
      - target: 514
        published: 514
        protocol: tcp
      - target: 514
        published: 514
        protocol: udp
    volumes:
      - "/vol/data:/data"
    env_file:
      - "./librenms.env"
    environment:
      - "TZ=\${TZ}"
      - "PUID=\${PUID}"
      - "PGID=\${PGID}"
      - "DB_HOST=db"
      - "DB_NAME=\${MYSQL_DATABASE}"
      - "DB_USER=\${MYSQL_USER}"
      - "DB_PASSWORD=\${MYSQL_PASSWORD}"
      - "DB_TIMEOUT=60"
      - "SIDECAR_SYSLOGNG=1"
    restart: always

  snmptrapd:
    image: librenms/librenms:latest
    container_name: librenms_snmptrapd
    hostname: librenms-snmptrapd
    cap_add:
      - NET_ADMIN
      - NET_RAW
    depends_on:
      - librenms
      - redis
    ports:
      - target: 162
        published: 162
        protocol: tcp
      - target: 162
        published: 162
        protocol: udp
    volumes:
      - "/vol/data:/data"
    env_file:
      - "./librenms.env"
    environment:
      - "TZ=\${TZ}"
      - "PUID=\${PUID}"
      - "PGID=\${PGID}"
      - "DB_HOST=db"
      - "DB_NAME=\${MYSQL_DATABASE}"
      - "DB_USER=\${MYSQL_USER}"
      - "DB_PASSWORD=\${MYSQL_PASSWORD}"
      - "DB_TIMEOUT=60"
      - "SIDECAR_SNMPTRAPD=1"
    restart: always
EOF-compose

cat << EOF-LibreNMS > /sbin/libre-nms.sh
#!/bin/bash
/usr/local/bin/docker-compose -f /etc/libre-nms/docker-compose.yml up --detach
EOF-LibreNMS

chmod +x /sbin/libre-nms.sh

cat << EOF-LibreNMS > /etc/cron.d/libre-nms
@reboot root /sbin/libre-nms.sh && rm -f /etc/cron.d/libre-nms
EOF-LibreNMS



# firewall
firewall-offline-cmd --add-port=8000/tcp