# Disk partitioning information
part pv.932 --fstype="lvmpv" --ondisk=sda --size=18952
part /boot --fstype="xfs" --ondisk=sda --size=1024
volgroup system --pesize=4096 pv.932
logvol / --fstype="xfs" --size=8192 --name=root --vgname=system
logvol /home --fstype="xfs" --size=1024 --name=home --vgname=system
logvol /tmp --fstype="xfs" --size=512 --name=tmp --vgname=system
logvol /var --fstype="xfs" --size=4096 --name=var --vgname=system
logvol /var/log --fstype="xfs" --size=2048 --name=var_log --vgname=system
logvol /var/log/audit --fstype="xfs" --size=2048 --name=var_log_audit --vgname=system
logvol swap --fstype="swap" --size=1024 --name=swap --vgname=system