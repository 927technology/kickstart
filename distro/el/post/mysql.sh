#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

#install mysql
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/mysql.txt

#persistent mysql db on host
mkdir -p /vol/var/lib/mysql

cat << EOF-MySQL > /sbin/mysql.sh
docker pull mysql:latest

docker run                              \
  -d                                    \
  -e MYSQL_ROOT_PASSWORD=ninepassword   \
  --name mysql                          \
  -p 3306:3306                          \
  -v /vol/var/lib/mysql:/var/lib/mysql  \
  --restart always                      \
  mysql:latest

EOF-MySQL

chmod +x /sbin/mysql.sh

cat << EOF-MySQL > /etc/cron.d/mysql
@reboot root /sbin/mysql.sh && rm -f /etc/cron.d/mysql
EOF-MySQL

# firewall
firewall-offline-cmd --add-port=3306/tcp
