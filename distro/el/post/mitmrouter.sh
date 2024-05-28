#!/bin/bash

#install docker-ce
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

#install mitmrouter
curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/mitmrouter.txt

# install dependancies
#yum erase -y firewalld
#yum install -y wget tar iptables-utils iptables

# create service account
useradd -m -d /etc/mitm mitm

# configure interface forwarding
echo net.ipv4.ip_forward = 1              >> /etc/sysctl.d/mitmrouter.conf
echo net.ipv6.conf.all.forwarding = 1     >> /etc/sysctl.d/mitmrouter.conf
echo net.ipv4.conf.all.send_redirects = 0 >> /etc/sysctl.d/mitmrouter.conf

# configure firewall
#iptables  -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80  -j REDIRECT --to-port 8080
#iptables  -t nat -A PREROUTING -i enp0s3 -p tcp --dport 443 -j REDIRECT --to-port 8080
#ip6tables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80  -j REDIRECT --to-port 8080
#ip6tables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 443 -j REDIRECT --to-port 8080

# create logging directory
mkdir /var/log/mitmrouter
chown mitm:mitm /var/log/mitmrouter
chmod 770 /var/log/mitmrouter

cat << EOF-MITMRouter > /sbin/mitmrouter.sh
docker pull 927technology/mitmrouter:0.0.2

docker run                      \
  -d                            \
  --rm                          \
  --hostname mitmrouter         \
  -p 80:8080                    \
  -p 443:8080                   \
  -p 8080:8080                  \
  -p 8081:8081                  \
  -e MODE=transparent           \
  -e WEB_HOST=0.0.0.0           \
  -v /etc/mitm:/etc/mitm        \
  -v /var/log/mitmrouter:/var/log/mitmrouter  \
  927technology/mitmrouter:0.0.2

EOF-MITMRouter

chmod +x /sbin/mitmrouter.sh

cat << EOF-Cron > /etc/cron.d/mitmrouter
@reboot mitm /sbin/mitmrouter.sh && rm -f /etc/cron.d/mitmrouter
EOF-Cron