#!/bin/bash

#banner
curl -s https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/post/header/docker.txt

#install yum utils
yum install -y yum-utils

#add docker repo
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#remove other container packages
yum remove -y docker docker-* podman runc

#install docker-ce
yum install -y docker-ce docker-ce-cli containerd.io

# enable services
systemctl enable docker