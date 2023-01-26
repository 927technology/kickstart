# Partition clearing information
ignoredisk --only-use=sda
#clearpart --all --initlabel --drives=sda

# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
