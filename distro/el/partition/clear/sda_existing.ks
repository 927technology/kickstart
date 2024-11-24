# Partition clearing information
# ignoredisk --only-use=sda
# clearpart --list=sda1,sda2
clearpart --all --initlabel --drives=sda

# System bootloader configuration
# bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
bootloader --location=mbr --boot-drive=sda

#sort out invalid partition tables
#zerombr
