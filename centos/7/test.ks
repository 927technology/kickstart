#version=DEVEL

# System authorization information
auth --enableshadow --passalgo=sha512

# insall method
install
cmdline
#cdrom
url=http://mirror.centos.org/centos/7/os/x86_64/images/pxeboot/
reboot

#repositories
repo --name=base --baseurl=http://mirror.centos.org/centos/7/os/x86_64
repo --name=updates --baseurl=http://mirror.centos.org/centos/7/updates/x86_64
repo --name=extras --baseurl=http://mirror.centos.org/centos/7/extras/x86_64
repo --name=centosplus --baseurl=http://mirror.centos.org/centos/7/centosplus/x86_64
repo --name=epel --baseurl=http://mirrors.fedoraproject.org/pub/epel/7/SRPMS



# Run the Setup Agent on first boot
firstboot --disable

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network  --hostname=nms

# Root password
rootpw --iscrypted $6$19KOuS2pPuJoRZcg$1UOOjGpwA2W3YExpHnegtPOOp7bvBvudsuJBOjbs4LGjsxLGM.Sdd9tOKtcEVSI35MUJxj3uuar5wJauslTEH.

#disk configuration
ignoredisk --only-use=sda
zerombr
clearpart --all --drives=sda --initlabel
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda

part /boot --fstype ext3 --ondisk=sda --size=150
part swap --ondisk=sda --size=1024
part pv.01 --size=1 --ondisk=sda --grow
volgroup vg00 pv.01
logvol  /  --vgname=vg00  --size=8192  --name=root
logvol  /var  --vgname=vg00  --size=4096  --name=var
logvol  /var/log  --vgname=vg00  --size=4096  --name=var_log
logvol  /var/log/audit  --vgname=vg00  --size=4096  --name=var_log_audit
logvol  /home  --vgname=vg00  --size=1028  --name=home
logvol  /tmp  --vgname=vg00  --size=1028  --name=lv_tmp


# System services
services --disabled="chronyd"

# System timezone
timezone America/Chicago --isUtc --nontp

%packages
@^minimal
@core
kexec-tools
-postfix
-telnet
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
