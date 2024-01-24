#!/bin/bash

application=mysql

# install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

# applicaiton header
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/${application}.txt

# configuration directory
mkdir -p /etc/${application}

# persistent data paths
mkdir -p /vol/var/lib/mysql

# create docker .env
cat << EOF-env > /etc/${application}/.env
MARIADB_ROOT_PASSWORD=ninepassword
MARIADB_VERSION=latest
EXTERNAL_PORT=3306
EOF-env

# create docker-compose
cat << EOF-compose > /etc/${application}/docker-compose.yml
name: mysql

services:
  db:
    container_name: db
    environment:
      - "MARIADB_ROOT_PASSWORD=\${MARIADB_ROOT_PASSWORD}"
    image: mariadb:\${MARIADB_VERSION}
    ports:
      - target: 3306
        published: \${EXTERNAL_PORT}
        protocol: tcp
    restart: always
    volumes:
      - "/vol/var/lib/mysql:/var/lib/mysql:Z"

EOF-compose

# create launcher
cat << EOF-launcher > /sbin/${application}.sh
#!/bin/bash
/usr/local/bin/docker-compose -f /etc/${application}/docker-compose.yml up --detach
EOF-launcher

chmod +x /sbin/${application}.sh

# create cron job
cat << EOF-cron > /etc/cron.d/${application}
@reboot root /sbin/${application}.sh && rm -f /etc/cron.d/${application}
EOF-cron

chmod +x /usr/local/bin/mariadb

# firewall
firewall-offline-cmd --add-port=3306/tcp
