# Install Source
url --mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=BaseOS-8

# Network
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/network/dhcp/no-ipv6.ks
network  --hostname=minimal.domain.tld

# Use install type
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/install/type/text.ks

%packages
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/packages/minimal.ks
%end

# YUM Repisitories
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/repo/x86_64/base.ks

# Disable the Setup Agent on first boot
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/firstboot/disable.ks

# Keyboard layouts
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/keyboard/us.ks

# System language
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/language/us/utf8.ks

# Network information
#network  --hostname=minimal.domain.tld

# Root password
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/user/root.ks

# System services
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/services/minimal.ks

# System timezone
timezone Etc/UTC --isUtc --nontp

# Partition clearing information
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