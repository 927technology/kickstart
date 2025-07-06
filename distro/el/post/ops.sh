#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

#install nessus
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/927ops.txt


cat << EOF-Ops > /sbin/ops.sh
docker pull 927technology/ops:latest

docker                                                    \
  run                                                     \
  --name ops-manager                                      \
  --hostname ops-manager                                  \
  --rm                                                    \
  --privileged                                            \
  -e BWS_ACCESS_TOKEN=0.bcb6b1ae-262d-49a8-afce-b29c001b0499.mj7neqB2wKKFjE6AQw5spd10oL61CP:KLsyWGNnNwhPpqIBRrx9Xw==                          \
  -e LIB_VERSION=0.4.0                                    \
  -e LOG_SERVER=192.168.1.21                              \
  -e ROLES=manager,web,jobserver                          \
  -e SECRET_PROVIDER=bitwarden                            \
  -e URL=https://927technology.github.io/ops              \
  -e _lib_root=/usr/local/lib/bash/0.4.0                  \
  -p 80:80                                                \
  -p 443:443                                              \
  927technology/ops:latest

EOF-Ops

chmod +x /sbin/ops.sh

cat << EOF-Cron > /etc/cron.d/ops
@reboot root /sbin/ops.sh && rm -f /etc/cron.d/ops
EOF-Cron

#firewall
firewall-offline-cmd --add-port=80/tcp
firewall-offline-cmd --add-port=443/tcp

