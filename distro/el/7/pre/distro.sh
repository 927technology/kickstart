#!/bin/bash

eval `cat /etc/os-release | grep ^ID=`
eval `cat /etc/os-release | grep ^VERSION_ID=`

arch=`/bin/uname -p`
url=https://raw.githubusercontent.com/927technology/kickstart/main

case ${VERSION_ID} in
    7.*)    major_version=7     ;;
    8.*)    major_version=8     ;;
    9.*)    major_version=9     ;;
esac

curl ${url}/distro/${ID}/${major_version}/install/source/${arch}/cloud.ks 1> /tmp/cloud.ks 2>/dev/null
