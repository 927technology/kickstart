#version=DEVEL

# System authorization information - generated by stage.sh pre script
%include /tmp/authorization.ks 

# Install Source - generated by stage.sh pre script
%include /tmp/cloud.ks

# Network - generated by stage.sh pre script
%include /tmp/network.ks
network  --hostname=minimal.domain.tld

# Install Type
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/install/type/text.ks

# YUM Repisitories - generated by stage.sh pre script
%include /tmp/repo.ks

# Disable the Setup Agent on first boot
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/firstboot/disable.ks

# Keyboard layouts - generated by stage.sh pre script
%include /tmp/keyboard.ks

# System language 
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/language/us/utf8.ks

# Root password
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/user/root.ks

# System services - generated by stage.sh pre script
%include /tmp/services.ks

# System timezone
%include https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/ntp/utc.ks

# Disk partitioning information - generated by stage.sh pre script
%include /tmp/partition.ks

#packages - generated by stage.sh pre script
%packages
%include /tmp/packages.ks
%end

#addon - generated by stage.sh pre script
%include /tmp/addon.ks

#anaconda - generated by stage.sh pre script
%include /tmp/anaconda.ks

%pre --log=/root/pre.log
# output pre to Terminal
exec < /dev/tty6 > /dev/tty6
chvt 6
#enter pre scripts here

curl https://raw.githubusercontent.com/927technology/kickstart/main/distro/el/pre/stage.sh | /bin/bash

# return to locally scheduled installer
chvt 1
%end

%post --log=/root/post.log
# Output Post to Terminal
exec < /dev/tty6 > /dev/tty6
chvt 6
#enter post scripts here

# return to locally scheduled installer
chvt 1
%end