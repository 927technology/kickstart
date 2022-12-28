#version=RHEL8
#text

# Install Source
url --mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=BaseOS-8
#%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/install/source/x86_64/cloud.ks

# Network
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/network/dhcp/no-ipv6.ks
network  --hostname=minimal.domain.tld

# Use install type
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/install/type/text.ks


# YUM Repisitories
%include https://raw.githubusercontent.com/927technology/kickstart/main/rocky/8/ks/repo/x86_64/base.ks


%packages
@^minimal-environment
%end

lang en_US.UTF-8

# YUM Repisitories
# repo --name=base --mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=BaseOS-8


# Disable the Setup Agent on first boot
firstboot --disable

# Keyboard layouts
keyboard --xlayouts='us'

# System language

# Network information
#network  --hostname=host.domain.tld

# Root password
rootpw --iscrypted $6$19KOuS2pPuJoRZcg$1UOOjGpwA2W3YExpHnegtPOOp7bvBvudsuJBOjbs4LGjsxLGM.Sdd9tOKtcEVSI35MUJxj3uuar5wJauslTEH.

# System services

# System timezone
timezone Etc/UTC --isUtc --nontp

# Partition clearing information
ignoredisk --only-use=sda
clearpart --all --initlabel --drives=sda

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
