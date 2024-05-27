# install dependancies
yum erase firewalld
yum install -y wget tar iptables-utils iptables

# create service account
useradd -m -d /etc/mitm mitm

# get and install binaries
wget https://raw.githubusercontent.com/927technology/kickstart/main/files/mitmproxy-10.3.0-linux-x86_64.tar.gz
tar xzf mitmproxy-10.3.0-linux-x86_64.tar.gz -C /usr/local/

# configure interface forwarding
echo net.ipv4.ip_forward = 1              >> /etc/sysctl.d/mitmproxy.conf
echo net.ipv6.conf.all.forwarding = 1     >> /etc/sysctl.d/mitmproxy.conf
echo net.ipv4.conf.all.send_redirects = 0 >> /etc/sysctl.d/mitmproxy.conf

# configure firewall
iptables  -t nat -A PREROUTING -i eth0 -p tcp --dport 80  -j REDIRECT --to-port 8080
iptables  -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8080
ip6tables -t nat -A PREROUTING -i eth0 -p tcp --dport 80  -j REDIRECT --to-port 8080
ip6tables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8080

# create systemd unit file
cat < UNIT.EOF >> /etc/systemd/system/mitmrouter.service
[Unit]
Description=MITM Proxy
After=network.target

[Service]
ExecStart=/usr/local/bin/mitmweb --anticomp --listen-port 8080 --mode transparent --no-web-open-browser --save-stream-file /var/log/mitmproxy/transparent.log --web-port 8081 --set web_host=0.0.0.0 --showhost

Restart=always
User=mitm

[Install]
WantedBy=multi-user.target

UNIT.EOF

# configure systemd
systemctl daemon-reload
systemctl enable mitmrouter.service
systemctl start mitmrouter.service