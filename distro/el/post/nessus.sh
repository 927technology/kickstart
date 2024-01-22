#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

#install nessus
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/nessus.txt


cat << EOF-Nessus > /etc/init.d/nessus.sh
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

#firewall
firewall-offline-cmd --add-port=8834/tcp

