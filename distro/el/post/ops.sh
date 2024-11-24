#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

#install nessus
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/nessus.txt


cat << EOF-Ops > /sbin/ops.sh
docker pull 927technology/ops:latest

docker run                    \
  -d                          \
  -e MANAGEMENT=true          \
  -e WORKER=true              \
  --name ops-ms               \
  --hostname ops-ms           \
  -p 80:80                    \
  -p 443:443                  \
  --restart always            \
  927technology/ops:latest

EOF-Ops

chmod +x /sbin/ops.sh

cat << EOF-Cron > /etc/cron.d/ops
@reboot root /sbin/ops.sh && rm -f /etc/cron.d/ops
EOF-Cron

#firewall
firewall-offline-cmd --add-port=80/tcp

