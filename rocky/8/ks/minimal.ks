#version=RHEL8
text

# Install Source
url --mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=BaseOS-8

%packages
@^minimal-environment
%end

lang en_US.UTF-8

# YUM Repisitories
repo --name=base --mirrorlist=https://mirrors.rockylinux.org.mirrorlistarch=x86_64&repo=BaseOS-8


# Disable the Setup Agent on first boot
firstboot --disable

# Keyboard layouts
keyboard --xlayouts='us'

# System language

# Network information
network  --hostname=host.domain.tld

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
