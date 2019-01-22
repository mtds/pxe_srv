This directory contains **static boot configurations** (not that 
references in `../once` have precedents).

Example [iPXE](http://ipxe.org/cmd) configuration:

```
#!ipxe
kernel path/to/vmlinux initrd=initrd.img
initrd path/to/initrd.img
boot || goto shell
```
