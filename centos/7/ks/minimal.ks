#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# Use Network installation
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/install/source/x96_64/cloud.ks

# Use install type
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/install/type/text.ks

# YUM Repisitories
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/repo/centos/x86_64/base.ks
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/repo/centos/x86_64/epel.ks

# Disable the Setup Agent on first boot
firstboot --disable

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/network/dhcp/no-ipv6.ks
network  --hostname=host.domain.tld

# Root password
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/user/root.ks

# System services
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/services/minimal.ks

# System timezone
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/ntp/utc.ks


# Partition clearing information
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/partition-clear-sda.ks


# Disk partitioning information
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/partition-stig.ks

#packages
%packages
%include raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/packages/minimal.ks
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
