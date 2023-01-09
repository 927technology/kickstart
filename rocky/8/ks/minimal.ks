# Install Source
url --mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=BaseOS-8

# Network
#network --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/network/dhcp/no-ipv6.ks
network  --hostname=minimal.domain.tld

# Use install type
text
reboot
#%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/install/type/text.ks


# YUM Repisitories
#%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/repo/x86_64/base.ks


%packages
@^server-product-environment
kexec-tools
#%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/packages/minimal.ks
%end

# YUM Repisitories
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/repo/x86_64/base.ks

# Disable the Setup Agent on first boot
firstboot --disable
#%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/firstboot/disable.ks

# Keyboard layouts
keyboard --xlayouts='us'
#%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/keyboard/us.ks

# System language
lang en_US.UTF-8#
#%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/language/us/utf8.ks

# Root password
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/user/root.ks

# System services

# System timezone
timezone Etc/UTC --isUtc --nontp

# Partition clearing information
#clearpart --all --initlabel --drives=sda
#ignoredisk --only-use=sda
#clearpart --none --initlabel

#part pv.932 --fstype="lvmpv" --ondisk=sda --size=18952
#part /boot --fstype="xfs" --ondisk=sda --size=1024
#volgroup system --pesize=4096 pv.932
#logvol / --fstype="xfs" --size=8192 --name=root --vgname=system
#logvol /home --fstype="xfs" --size=1024 --name=home --vgname=system
#logvol /tmp --fstype="xfs" --size=512 --name=tmp --vgname=system
#logvol /var --fstype="xfs" --size=4096 --name=var --vgname=system
#logvol /var/log --fstype="xfs" --size=2048 --name=var_log --vgname=system
#logvol /var/log/audit --fstype="xfs" --size=2048 --name=var_log_audit --vgname=system
#logvol swap --fstype="swap" --size=1024 --name=swap --vgname=system

%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/partition/clear/sda.ks

%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/partition/stig.ks



%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

#%post --log=/root/post.log
# Output Post to Terminal
#exec < /dev/tty4 > /dev/tty4

#%end
