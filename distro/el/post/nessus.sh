#!/bin/bash
type=${1}

case ${type} in 
  local | *)
    nessus_version=10.5.2

    case ${MAJOR_VERSION} in
      7)
        arch==x86_64
        build=es7
      ;;
      8)
        arch==x86_64
        build=es8
      ;;
      9)
        arch==x86_64
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


    #firewall
    firewall-offline-cmd --add-port=8834/tcp
  ;;
  docker)
    yum install -y yum-utils
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable docker
    systemctl start docker

    docker pull tenable/nessus:oracle-latest

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

