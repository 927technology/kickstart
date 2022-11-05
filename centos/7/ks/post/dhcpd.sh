#!/bin/bash

rm -f /etc/dhcp/dhcpd.conf
wget https://raw.githubusercontent.com/927technology/kickstart/main/etc/dhcp/dhcpd.conf -P /etc/dhcp/