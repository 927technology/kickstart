#!/bin/bash

url=https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.4.1-es7.x86_64.rpm
package=`echo ${url} | awk -F"/" '{print $NF}'`

#download nessus rpm pakage per tennable preferred method
curl --request GET --url ${url} --output ${package}

#install the rpm
rpm -ihv ${package}

#enable the service
systemctl enable nessusd

#firewall
firewall-offline-cmd --add-port=8834/tcp