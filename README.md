# Deployment

## [Setting Up a PXE Server](./docs/pxe.md)



## Directions
Boot centos 7 cd.  When the boot screen appears press <TAB>
Remove text and replace with:
vmlinuz initrd=initrd.img ks=https://raw.githubusercontent.com/927technology/kickstart/main/centos/7/test.ks
