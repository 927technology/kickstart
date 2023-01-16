# YUM Repisitories
repo --name=base --mirrorlist=http://mirror.centos.org/?release=$stream&arch=$basearch&repo=BaseOS&infra=$infra
repo --name=appstream --mirrorlist=--mirrorlist=http://mirror.centos.org/?release=$stream&arch=$basearch&repo=AppStream&infra=$infra
