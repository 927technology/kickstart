# Disk partitioning information
part /boot              --fstype="xfs"      --size=1024     --ondisk=sda
part pv.01              --fstype="lvmpv"    --size=28672    --ondisk=sda
part pv.02              --fstype="lvmpv"    --size=1024     --ondisk=sda

#volume group system
volgroup system         --pesize=4096 pv.01
logvol /home            --fstype="xfs"      --size=1024     --name=home             --vgname=system
logvol /                --fstype="xfs"      --size=10240    --name=root             --vgname=system
logvol /var             --fstype="xfs"      --size=4096     --name=var              --vgname=system
logvol /var/log         --fstype="xfs"      --size=4096     --name=var_log          --vgname=system
logvol swap             --fstype="swap"     --size=2048     --name=swap             --vgname=system
logvol /tmp             --fstype="xfs"      --size=1024     --name=tmp              --vgname=system
logvol /var/log/audit   --fstype="xfs"      --size=2048     --name=var_log_audit    --vgname=system

volgroup system         --pesize=4096 pv.02
logvol /etc/audit       --fstype="xfs"      --size=5        --name=etc_audit        --vgname=data
logvol /etc/pam.d       --fstype="xfs"      --size=5        --name=etc_pamd         --vgname=data
logvol /etc/ssh         --fstype="xfs"      --size=5        --name=etc_ssh          --vgname=data