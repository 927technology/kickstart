# Disk partitioning information
#part pv.336 --fstype="lvmpv" --ondisk=sda --size=28600
part pv.01 --fstype="lvmpv" --ondisk=sda --size=28600
part /boot --fstype="xfs" --ondisk=sda --size=1024
volgroup system --pesize=4096 pv.01
logvol /home --fstype="xfs" --size=1024 --name=home --vgname=system
logvol / --fstype="xfs" --size=12288 --name=root --vgname=system
logvol /var --fstype="xfs" --size=4096 --name=var --vgname=system
logvol /var/log --fstype="xfs" --size=4096 --name=var_log --vgname=system
logvol swap --fstype="swap" --size=2048 --name=swap --vgname=system
logvol /tmp --fstype="xfs" --size=1024 --name=tmp --vgname=system
logvol /var/log/audit --fstype="xfs" --size=2048 --name=var_log_audit --vgname=system
