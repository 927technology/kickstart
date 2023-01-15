#version=DEVEL

# System authorization information
auth --enableshadow --passalgo=sha512

# Install Source - generated by stage.sh pre script
%include /tmp/cloud.ks

# Network
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/network/dhcp/no-ipv6.ks
network  --hostname=minimal.domain.tld

# Use install type
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/install/type/text.ks

# YUM Repisitories - generated by stage.sh pre script
%include /tmp/repo.ks

# Disable the Setup Agent on first boot
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/firstboot/disable.ks

# Keyboard layouts
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/keyboard/us.ks

# System language
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/language/us/utf8.ks

# Network information
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/network/dhcp/no-ipv6.ks
network  --hostname=host.domain.tld

# Root password
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/user/root.ks

# System services
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/services/minimal.ks

# System timezone
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/ntp/utc.ks

# Disk partitioning information - generated by stage.sh pre script
%include /tmp/partition.ks

#packages
%packages
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/packages/minimal.ks
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'
%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

%pre --log=/root/post.log
curl https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/pre/stage.sh | bash
%end

%post --log=/root/post.log
# Output Post to Terminal
exec < /dev/tty4 > /dev/tty4
%end