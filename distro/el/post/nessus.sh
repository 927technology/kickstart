#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh

#install nessus
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/nessus.txt

docker pull tenable/nessus:latest-oracle

docker run                    \
  -d                          \
  -e USERNAME=nineadmin       \
  -e PASSWORD=ninepassword    \
  --name nessus               \
  -p 8834:8834                \
  --restart always            \
  --rm                        \
  -v /opt/nessus:/opt/nessus  \
  tenable/nessus:latest-oracle

#firewall
firewall-offline-cmd --add-port=8834/tcp