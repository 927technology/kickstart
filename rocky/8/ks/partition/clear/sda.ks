# Partition clearing information
#ignoredisk --only-use=sda
clearpart --all --initlabel --drives=sda
#clearpart --all --initlabel

# System bootloader configuration
#bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
#bootloader --append=" crashkernel=auto" --location=mbr