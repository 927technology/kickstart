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
MYSQL_PASSWORD=ninepassword
MYSQL_VERSION=latest
EXTERNAL_PORT=3306
EOF-env

# create docker-compose
cat << EOF-compose > /etc/${application}/docker-compose.yml
name: mysql

services:
  db:
    container_name: db
    image: mysql:\${MYSQL_VERSION}
    ports:
      - target: 3306
        published: \${EXTERNAL_PORT}
        protocol: tcp
    restart: always
    volumes:
      - "/vol/var/lib/mysql:/var/lib/mysql"

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

# firewall
firewall-offline-cmd --add-port=3306/tcp
