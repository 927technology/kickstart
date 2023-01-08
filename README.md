# Deployment


## Install Enterprise Linux (EL) from an internet Kickstart

This is a completely automated install.   

> OS Requirements </br>
> 1 or more network interfaces with internet connectivity </br>
> 1 or more processors </br>
> 2048Mb or more memory 

1. You will need bootable media.  Any install media will work for the version of the OS you wish to install.
    * [CentOS](https://www.centos.org/download/)
    * [Rocky](https://rockylinux.org/download/)
1. Boot the install media on a computer or VM that has internet connectivity
1. Interrupt the boot media menu usually by pressing \<TAB\> which will display the boot command
    ![kickstart1](./docs/images/kickstart1.png "Boot Menu")
1. Append to the end of he boot command
    ```
    inst.ks=https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/minimal.ks

    ```

    The resulting command should look like
    ```
    > vmlinuz initrd=initrd.img inst.stage2=hd:LABEL=CentOS\x207\x20x86_64 rd.live.check quiet inst.ks=https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/minimal.ks
    ```
    ![kickstart2](./docs/images/kickstart2.png "Boot Menu 2")

    * Additional Kickstarts are available
        * Centos 7
            > Apache Web Server
            inst.ks=https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/httpd.ks

            > DHCP Server
            inst.ks=https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/dhcpd.ks
            
            > Nessus
            inst.ks=https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/nessus.ks
                      
            > TFTP Server
            inst.ks=https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/ks/tftp.ks
        * Rocky 8
            > Minimal
            inst.ks=https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/minimal.ks
1. Press \<Enter\>.
1. The installation will take a moment to complete as it pulls updated packages from the internet during the install.  This time for this process is dependant on the speed of your internet connetion.
1. Once the system reboots
    * Login

        > Default Login: root

        > Default Password: 1qaz2wsx!QAZ@WSX
    * Change root's password
        ```
        passwd
        ```
    * create a privileged non-root user where \<username\> is your new user
        ```
        useradd <username>

        passwd <username>
        
        echo "<username> ALL=(ALL:ALL) ALL" > /etc/sudoers.d/<username>
        ```
    * Logout/Login as new non-root user and you are ready to go

---


