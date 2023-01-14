#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# Install Source
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/install/source/x86_64/cloud.ks

# Network
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/network/dhcp/no-ipv6.ks
network  --hostname=minimal.domain.tld

# Use install type
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/install/type/text.ks

# YUM Repisitories
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/repo/x86_64/base.ks
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/repo/x86_64/epel.ks

# Disable the Setup Agent on first boot
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/firstboot/disable.ks

# Keyboard layouts
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/keyboard/us.ks

# System language
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/language/us/utf8.ks

# Network information
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/network/dhcp/no-ipv6.ks
network  --hostname=host.domain.tld

# Root password
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/user/root.ks

# System services
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/services/minimal.ks

# System timezone
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/ntp/utc.ks


# Partition clearing information
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/partition/clear/sda.ks


# Disk partitioning information
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/partition/stig.ks

#packages
%packages
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/packages/minimal.ks
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

%post --log=/root/post.log
# Output Post to Terminal
exec < /dev/tty4 > /dev/tty4

%end
