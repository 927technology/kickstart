#!/bin/bash
type=${1}

#variables
#url=${1}                                                                                           #url from kickstart                                                                                                   
                                                                                                    #source varables provided by kickstart
source /tmp/variables.v

                                                                                                    #source bools from git
/bin/curl -sf ${url}/distro/el/pre/lib/bash/${bash_lib_ver}/bool.v                                   > /tmp/bool.v
source /tmp/bool.v
                                                                                                    #source dracut commands from git
/bin/curl -sf ${url}/distro/el/pre/lib/bash/${bash_lib_ver}/cmd_dracut.v                             > /tmp/cmd_dracut.v
source /tmp/cmd_dracut.v

for library in `${cmd_echo} ${libraries} | ${cmd_sed} 's/,/ /g'`; do
    /bin/curl -s ${url}/distro/el/pre/lib/bash/${bash_lib_ver}/${library}.f                         >> /tmp/${library}.f
    source /tmp/${library}.f
done

eval `${cmd_cat} /etc/os-release | ${cmd_grep} ^ID=`
eval `${cmd_cat} /etc/os-release | ${cmd_grep} ^VERSION_ID=`

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

