#!/bin/bash

# enable services
systemctl enable mysql

# firewall
firewall-offline-cmd --add-port=3306/tcp
