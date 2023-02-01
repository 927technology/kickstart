#!/bin/bash

# enable services
systemctl enable httpd

# firewall
firewall-offline-cmd --add-port=80/tcp
firewall-offline-cmd --add-port=443/tcp
