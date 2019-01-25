File                      | Description
--------------------------|-----------------------------------------
[bin/ipxe-kickstart][ik]  | Render an iPXE boot configuration for a target Kickstart file

Render a custom iPXE configuration for a Kickstart [1] file (cf. [default.ks](7/default.ks)

```bash
# using a PXESrv VM instance
kickstart=http://$(vm ip $PXESRV_VM_INSTANCE):$PXESRV_PORT/centos/7/default.ks
# redner the corresponding file in PXESrv document root
ipxe-kickstart $kickstart > $PXESRV_ROOT/centos/7/default
```

The example above is use with development environment described in [DEVELOPMENT.md][dv].

[ik]: ../../bin/ipxe-kickstart
[dv]: ../../DEVELOPMENT.md

### Reference

[1] Kickstart Documentation  
<https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html>

[2] Anaconda Network Configuration  
<https://fedoraproject.org/wiki/Anaconda/Network>
