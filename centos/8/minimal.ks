#version=RHEL8
ignoredisk --only-use=sda
autopart --type=lvm
# Partition clearing information
clearpart --none --initlabel
# Use graphical install
graphical
# Use CDROM installation media
cdrom
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network  --hostname=lch-02
repo --name="AppStream" --baseurl=file:///run/install/repo/AppStream
# Root password
rootpw --iscrypted $6$Iqf2tQ0W4GrwIJJ5$nhFDU8z5eBs7LqTRQRdxuXP7mV22Kis8hcd3sJHlHXmPEH/MxrOJ0QneRqbQSYe47qbgNuG7qARHXzQmnm3IR1
# Run the Setup Agent on first boot
firstboot --enable
# Do not configure the X Window System
skipx
# System services
services --disabled="chronyd"
# System timezone
timezone America/Chicago --isUtc --nontp

%packages
@^minimal-environment
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
