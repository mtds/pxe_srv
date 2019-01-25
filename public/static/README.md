This directory contains **static boot configurations** (not that 
references in `../once` have precedents). PXESrv looks for a **file
called like the client IP-address** within this directory, and returns
it content.

Example [iPXE](http://ipxe.org/cmd) configuration, redirect to another 
boot configuration file with `chain`:

```
#!ipxe
chain ../centos/7/default
```

The target path could be any URL, or an absolute/relative path in 
the file-system.

Provide a single boot-configuration to multiple client by creating
a single configuration file and using soft links `ln -s` called like
the client IP-addresses to reference it.
