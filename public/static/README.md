This directory contains **static boot configurations** (not that
references in [$PXESRV_ROOT/once](../once) have precedents). PXESrv
looks for a **file called like the client IP-address** within this
directory, and returns its content.


Redirect to another boot configuration file with `chain`
(cf. [iPXE commands](http://ipxe.org/cmd))

```
#!ipxe
chain ../centos/7/default
```

The target path could be any URL, or an absolute/relative path in
the file-system.

Provide the same boot-configuration to multiple clients by creating
a single configuration file and using soft links `ln -s` called like
the client IP-addresses to reference it.
