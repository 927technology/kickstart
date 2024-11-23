# Generated by Anaconda 34.25.4.9
# Generated by pykickstart v3.32
#version=OL9
# Use graphical install
text
%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

# Keyboard layouts
keyboard --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network  --hostname=minimal.ks.927.technology

%packages
@^minimal-environment

%end

# Run the Setup Agent on first boot
firstboot --enable

# Generated using Blivet version 3.6.0
ignoredisk --only-use=sda
# Partition clearing information
# clearpart --list=sda1,sda2
zerombr
#clearpart --none --initlabel
# Disk partitioning information
part /boot --fstype="xfs" --ondisk=sda --size=953
part pv.1774 --fstype="lvmpv" --ondisk=sda --size=26416
volgroup system --pesize=4096 pv.1774
logvol /var/log --fstype="xfs" --size=2048 --name=var_log --vgname=system
logvol swap --fstype="swap" --size=3814 --name=swap --vgname=system
logvol /home --fstype="xfs" --size=953 --name=home --vgname=system
logvol /var/log/audit --fstype="xfs" --size=1907 --name=var_log_audit --vgname=system
logvol / --fstype="xfs" --size=15258 --name=root --vgname=system
logvol /tmp --fstype="xfs" --size=512 --name=tmp --vgname=system
logvol /var --fstype="xfs" --size=1907 --name=var --vgname=system

# System timezone
timezone America/Chicago --utc

# Root password
rootpw --iscrypted --allow-ssh $6$ToknfnabIao6m/Al$8qwOPYlhlw2mwBvMWUfIjTWw6UgPUSaNkgQK7R1ryRrge.mdMpPm95AWhX1zjK0eg1sH4.Lp3jsPBX0OwAA2X1

