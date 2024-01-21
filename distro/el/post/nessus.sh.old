#!/bin/bash
type=${1}

eval `cat /etc/os-release | grep ^ID=`
eval `cat /etc/os-release | grep ^VERSION_ID=`

case ${VERSION_ID} in
    7 | 7.*)    major_version=7     ;;
    8 | 8.*)    major_version=8     ;;
    9 | 9.*)    major_version=9     ;;
esac

case ${type} in 
  local | *)
    nessus_version=10.5.2

    case ${major_version} in
      7)
        arch=x86_64
        build=es7
      ;;
      8)
        arch=x86_64
        build=es8
      ;;
      9)
        arch=x86_64
        build=es9
      ;;
    esac
      
    url=https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-${nessus_version}-${build}.${arch}.rpm

    package=`echo ${url} | awk -F"/" '{print $NF}'`

    #download nessus rpm pakage per tennable preferred method
    curl --request GET --url ${url} --output ${package}

    #install the rpm
    rpm -ihv ${package}

    #enable the service
    systemctl enable nessusd
  ;;
  docker)
    #install docker-ce
    curl -sk https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/docker.sh | /bin/bash

    docker pull tenable/nessus:latest-oracle

    docker run                    \
      -d                          \
      -e USERNAME=nineadmin       \
      -e PASSWORD=ninepassword    \
      --name nessus               \
      -p 8834:8834                \
      --restart always            \
      --rm                        \
      -v /opt/nessus:/opt/nessus  \
      tenable/nessus:latest-oracle
  ;;
esac

#firewall
firewall-offline-cmd --add-port=8834/tcp