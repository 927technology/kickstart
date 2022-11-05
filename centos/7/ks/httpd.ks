#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# Network
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/install/source/x86_64/cloud.ks
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/network/dhcp/no-ipv6.ks
network  --hostname=httpd.domain.tld

# Firewall
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/firewall/httpd.ks

# Text Install
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/install/type/text.ks

# YUM Repisitories
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/repo/x86_64/base.ks
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/repo/x86_64/epel.ks

# First Boot
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/firstboot/disable.ks

# Keyboard
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/keyboard/us.ks

# Language
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/language/us/utf8.ks

# Root Password
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/user/root.ks

# Services
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/services/httpd.ks

# Timezone
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/ntp/utc.ks


# Partition 
## Clear
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/partition/clear/sda.ks

## Create
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/partition/stig.ks

# Skip X
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/packages/skipx.ks

# Packages
%packages
%include https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/packages/httpd.ks
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

curl -s https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/post/httpd.sh | bash
%end
