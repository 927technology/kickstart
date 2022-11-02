#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# Use Network installation
url --mirrorlist=http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=os

# Use text install
text
reboot

# YUM Repisitories
repo --name="Centos-7 - Base" --mirrorlist=http:/mirrorlist.centos.org/?release=7&arch=x86_64&repo=os
repo --name="Centos-7 - Updates" --mirrorlist=http:/mirrorlist.centos.org/?release=7&arch=x86_64&repo=updates
repo --name="Extra Packages for Enterprise Linux 7" --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=x86_64

# Disable the Setup Agent on first boot
firstboot --disable

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=host.domain.tld

# Root password
rootpw --iscrypted $6$19KOuS2pPuJoRZcg$1UOOjGpwA2W3YExpHnegtPOOp7bvBvudsuJBOjbs4LGjsxLGM.Sdd9tOKtcEVSI35MUJxj3uuar5wJauslTEH.

# System services
services --disabled="chronyd"

# System timezone
timezone Etc/UTC --isUtc --nontp

# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda

# Partition clearing information
ignoredisk --only-use=sda
clearpart --all --initlabel

# Disk partitioning information
part pv.336 --fstype="lvmpv" --ondisk=sda --size=28600
part /boot --fstype="xfs" --ondisk=sda --size=1024
volgroup system --pesize=4096 pv.336
logvol /home --fstype="xfs" --size=1024 --name=home --vgname=system
logvol / --fstype="xfs" --size=12288 --name=root --vgname=system
logvol /var --fstype="xfs" --size=4096 --name=var --vgname=system
logvol /var/log --fstype="xfs" --size=4096 --name=var_log --vgname=system
logvol swap --fstype="swap" --size=2048 --name=swap --vgname=system
logvol /tmp --fstype="xfs" --size=1024 --name=tmp --vgname=system
logvol /var/log/audit --fstype="xfs" --size=4096 --name=var_log_audit --vgname=system

%packages
@^minimal
@core
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
