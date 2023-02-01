#!/bin/bash

# enable services
systemctl enable mysqld

# firewall
firewall-offline-cmd --add-port=3306/tcp
