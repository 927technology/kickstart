# Setup a PXE Imaging Environment

A PXE deployment server requires DHCP, TFTP, and a File Server.  Multiple file servers are supported including HTTP, HTTPS, FTP, and SFTP.  This example will only cover HTTP using Apache2 as a file source.

* DHCP Server
    * Install
        ```
        yum install -y dhcp

        firewall-cmd --permanent --add-service=dhcp
        firewall-cmd --reload
        ```
    * Configure
        > /etc/dhcp/dhcpd.conf 
        
        [Example](./etc/dhcp/dhcpd.conf)
        ```
        #add the following to your subnet or global configurations as needed

        next-server ${tftp_server_ip};

        option bootfile-name "pxelinux.0";
        ```
        Example Subnet
        ```
        subnet w.x.y.z netmask 255.255.255.0 {
            next-server <tftp_server_ip>;
            option bootfile-name "pxelinux.0"
            option domain-name-servers 8.8.8.8;
            option routers w.x.y.1;
            range w.x.y.10 w.x.y.255;
        }
        ```
        To eliminate iPXE boot loops add the following code to your subnet configuration.  Select either the pxe or ipxe boot option based on your configuration.
        ```
            if exist user-class and option user-class = "iPXE" {
                #ipxe boot
                filename = "http://<ipxe_boot_web_server>/default;

                #pxe boot
                filename = "pxelinux.0";
            } elsif { option client-architecture = 00:00 {
                filename = "undionly.kpxe";
            } else {
                filename = "ipxe.efi";
            }
        ```
    * Enable
        ```
        systemctl enable dhcpd
        ```
    * Start
        ```
        systemctl start dhcpd
        ```

* TFTP Server
    * Install
        ```
        yum install -y xinetd tftp-server syslinux

        firewall-cmd --permanent --add-service=tftp
        firewall-cmd --reload
        ```
    * Configure
        > /etc/xinetd.d/tftp
        ```
        service tftp
        {
            socket_type         = dgram
            protocol            = udp
            wait                = yes
            user                = root
            server              = /usr/sbin/in.ftpd
            server_args         = -c -s /var/lib/tftpboot
            disable             = no
            per_source          = 11
            cps                 = 100 2
            flags               = IPv4
        }
        ```
    * Enable
        ```
        systemctl enable xinetd
        ```
    * Start
        ```
        systemctl start xinetd
        ```
    * Create distro folder 
        ```
        mkdir -p /var/lib/tftpboot/centos/7/x86_64
        ```
    * Get requited boot files
        ```
        wget http://mirror.centos.org/centos/7/os/x86_64/images/pxeboot/vmlinuz -P /var/lib/tftpboot/centos/7/x86_64

        wget http://mirror.centos.org/centos/7/os/x86_64/images/pxeboot/initrd.img -P /var/lib/tftpboot/centos/7/x86_64
        
        wget https://boot.ipxe.org/undionly.kpxe -P /var/lib/tftpboot
        
        wget https://boot.ipxe.org/ipxe.efi -P /var/lib/tftpboot

        cp -R /usr/share/syslinux/* /var/lib/tftpboot
        ```
    * Boot menu
        ```
        mkdir -p /var/lib/tftpboot/pxelinux.cfg
        ```
        * edit default
            > /var/lib/tftpboot/pxelinux.cfg/default
            ```
            default menu.c32
            prompt 0
            timeout 30
            ONTIMEOUT install

            menu title My Boot Menu

            label install
                menu label Install CentOS 7 x86_64

                kernel centos/7/x86_64/vmlinuz
                append initrd=centos/7/x86_64/initrd.img showopts inst.repo=http://<web server ip>/centos/7/x86_64/os method=http://<web server ip>/repo/centos/7/os/x86_64/ rw ipv6.disable=1 ks=http://<web server ip>/centos/7/ks/<kickstart file>.ks ip=dhcp net.ifnames=0 biosdevname=0

            label local
                menu label Boot Local
                localboot 0x80
            ```
















* Web Server
    * Install
        ```
        yum install -y httpd

        firewall-cmd --permanent --add-service=http
        firewall-cmd --reload
        ```
    * Confgure
        > No additional cofiguration steps necessary
    * Enable
        ```
        systemctl enable httpd
        ```
    * Start
        ```
        systemctl start httpd
        ```
    * Download CentOS 7 Minimal ISO
        ```
        wget http://mirror.grid.uchicago.edu/pub/linux/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso -P /root
        ```
    * Mount CentOS 7 ISO
        ```
        mount -o loop /root/CentOS-7-x86_64-Minimal-2009.iso /mnt
        ```
    * Copy Centos 7 Distro folder
        ```
        #create distro folders
        mkdir -p /var/www/html/centos/7/x86_64/os
        mkdir -p /var/www/html/centos/7/ks

        #copy distro contents into webroot
        cp -r /mnt /var/www/html/centos/7/x86_64/os

        #set permissions on distro folder and contents
        chown root:apache -R /var/www/html/centos
        chmod -R 750 /var/www/html/centos 
        ```
    * Add Kickstart to repisitory
        ```
        #add kickstart file to /var/www/html/centos/7/ks
        chown root:apache /var/www/html/centos/7/ks/<kickstart>.ks
        chmod 755 /var/www/html/centos/7/ks/<kickstart>.ks
        ```

* Cleanup
    * Unmount CentOS ISO
        ```
        umount /mnt
        ```
    * Delete CentOS ISO
        ```
        rm -f /root/CentOS-7-x86_64-Minimal-2009.iso
        ```
    * Cleanup yum
        ```
        yum clean all
        ```


* PXE Clients
    * Requirements
        * 1 CPU
        * 2 GB RAM
        * 30 GB Disk Space
        * 1 NIC with PXE enabled