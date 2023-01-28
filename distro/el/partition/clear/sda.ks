# Partition clearing information
ignoredisk --only-use=sda
clearpart --list=sda1,sda2

# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda

#sort out invalid partition tables
zerombr
