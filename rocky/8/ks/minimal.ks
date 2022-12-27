#version=RHEL8
# System authorization information
auth --enableshadow --passalgo=sha512

# Install Source
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/install/source/x86_64/cloud.ks

# Network
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/network/dhcp/no-ipv6.ks
network  --hostname=minimal.domain.tld

# Use install type
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/install/type/text.ks

# YUM Repisitories
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/repo/x86_64/base.ks
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/repo/x86_64/epel.ks

# Disable the Setup Agent on first boot
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/firstboot/disable.ks

# Keyboard layouts
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/keyboard/us.ks

# System language
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/language/us/utf8.ks

# Network information
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/network/dhcp/no-ipv6.ks
network  --hostname=host.domain.tld

# Root password
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/user/root.ks

# System services
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/services/minimal.ks

# System timezone
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/ntp/utc.ks


# Partition clearing information
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/partition/clear/sda.ks


# Disk partitioning information
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/partition/stig.ks

#packages
%packages
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/packages/minimal.ks
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
