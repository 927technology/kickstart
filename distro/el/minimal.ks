#version=DEVEL

# System authorization information - generated by stage.sh pre script
%include /tmp/authorization.ks 

# Install Source - generated by stage.sh pre script
%include /tmp/source.ks

# Network - generated by stage.sh pre script
%include /tmp/network.ks
network  --hostname=minimal.domain.tld

# Install Type - generated by stage.sh pre script
#%include /tmp/type.ks
text
#cdrom
reboot --eject

# YUM Repisitories - generated by stage.sh pre script
%include /tmp/repo.ks

# Disable the Setup Agent on first boot - generated by stage.sh pre script
%include /tmp/firstboot.ks

# Keyboard layouts - generated by stage.sh pre script
%include /tmp/keyboard.ks

# System language - generated by stage.sh pre script
%include /tmp/language.ks

# Root password - generated by stage.sh pre script
%include /tmp/users.ks

# System services - generated by stage.sh pre script
%include /tmp/services.ks

# System timezone - generated by stage.sh pre script
%include /tmp/timezone.ks

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
export branch=main
export build=minimal
export url=https://raw.githubusercontent.com/927technology/kickstart/${branch}

/bin/curl -s ${url}/distro/el/pre/header.txt
/bin/curl -s ${url}/distro/el/pre/variables/${build}.v > /tmp/variables.v
/bin/curl -s ${url}/distro/el/pre/stage.sh | /bin/bash
/bin/curl -s ${url}/distro/el/pre/footer.txt

# return to locally scheduled installer
chvt 1
%end

%post --log=/root/post.log
# Output Post to Terminal
exec < /dev/tty6 > /dev/tty6
chvt 6
#enter post scripts here
export branch=main
export build=minimal
export url=https://raw.githubusercontent.com/927technology/kickstart/${branch}

/bin/curl -s ${url}/distro/el/pre/header.txt
/bin/curl -s ${url}/distro/el/pre/variables/${build}.v > /tmp/variables.v
/bin/curl -sf ${url}/distro/el/post/${build}.sh | /bin/bash
/bin/curl -s ${url}/distro/el/pre/footer.txt

# return to locally scheduled installer
chvt 1
%end