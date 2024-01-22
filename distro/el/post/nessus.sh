#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

#install nessus
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/nessus.txt


cat << EOF-Nessus > /sbin/nessus.sh
docker pull tenable/nessus:latest-oracle

docker run                    \
  -d                          \
  -e USERNAME=nineadmin       \
  -e PASSWORD=ninepassword    \
  --name nessus               \
  -p 8834:8834                \
  --restart always            \
  tenable/nessus:latest-oracle

EOF-Nessus

chmod +x /sbin/nessus.sh

cat << EOF-Cron > /etc/cron.d/nessus
@reboot root /sbin/nessus.sh && rm -f /etc/cron.d/nessus
EOF-Cron

#firewall
firewall-offline-cmd --add-port=8834/tcp

