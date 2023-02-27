#!/bin/bash

# enable services
systemctl enable docker
systemctl enable xrdp

# firewall
firewall-offline-cmd --add-port=3389/tcp
