# YUM Repisitories
#repo --name=base --mirrorlist=http://mirrorlist.centos.org/?release=8-Stream&arch=x86_64&repo=BaseOS&infra=stock
repo --name=base --mirrorlist=http://mirrorlist.centos.org/?release=$stream&arch=$basearch&repo=BaseOS&infra=$infra
repo --name=stream --mirrorlist=http://mirrorlist.centos.org/?release=$stream&arch=$basearch&repo=AppStream&infra=$infra
