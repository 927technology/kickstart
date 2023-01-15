#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# Install Source
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/install/source/x86_64/cloud.ks

# Network
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/network/dhcp/no-ipv6.ks
network  --hostname=dhcp.domain.tld

# Firewall
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/firewall/snort.ks

# Text Install
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/install/type/text.ks

# YUM Repisitories
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/repo/x86_64/base.ks

# First Boot
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/firstboot/disable.ks

# Keyboard
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/keyboard/us.ks

# Language
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/language/us/utf8.ks

# Root Password
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/user/root.ks

# Services
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/services/snort.ks

# Timezone
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/ntp/utc.ks


# Partition 
## Clear
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/partition/clear/sda.ks

## Create
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/partition/stig.ks

# Skip X
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/packages/skipx.ks

# Packages
%packages
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/packages/snort.ks
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
chvt 4

curl -s https://raw.githubusercontent.com/927technology/kickstart/main/distro/centos/7/post/dhcpd.sh | bash
%end
