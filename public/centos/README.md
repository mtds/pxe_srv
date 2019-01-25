# Kickstart

File                      | Description
--------------------------|-----------------------------------------
[bin/ipxe-kickstart][ik]  | Render an iPXE boot configuration for a target Kickstart file

Render a custom iPXE configuration for a Kickstart [1] file (cf. [default.ks](7/default.ks))

```bash
# using a PXESrv VM instance
kickstart=http://$(vm ip $PXESRV_VM_INSTANCE):$PXESRV_PORT/centos/7/default.ks
# create the corresponding file in PXESrv document root
ipxe-kickstart $kickstart > $PXESRV_ROOT/centos/7/default
```

The example above is used with development environment described in [DEVELOPMENT.md][dv].

[ik]: ../../bin/ipxe-kickstart
[dv]: ../../DEVELOPMENT.md

### Anaconda

Assemble a kernel command-line with custom options for the **Anaconda network configuration** [2]:

```bash
# basic network configuration
domain=.devops.test
dns_ip=10.10.0.10
gateway=10.10.0.1
netmask=255.255.0.0
network=10.10.0.0/16
iface=ib0
# load the InfiniBand drivers during early boot...
ib_drivers='rd.driver.post=mlx4_ib,ib_ipoib,ib_umad,rdma_ucm rd.neednet=1 rd.timeout=20 rd.retry=80'
# use iPXE intermingled variables [3] for node IP-address and name
# make sure the ib0 InfiniBand interface is configured and used for Kickstart
ip="ip=\${net0.dhcp/ip}::$gateway:$netmask:\${net0.dhcp/hostname}$domain:$iface:off ks.device=$iface"
route="rd.route=$network:$gateway:$iface"
# all custom kernel command-line options
```

Embed the custom kernel command-line into an iPXE boot-configuration file:

```bash
ipxe-kickstart \
        --cmdline "$ip $ib_drivers nameserver=$dns_ip $route" \
        --repo http://mirror.centos.org/centos/7/os/x86_64 \
        http://$(vm ip $PXESRV_VM_INSTANCE):$PXESRV_PORT/centos/7/default.ib.ks \
        > $PXESRV_ROOT/centos/7/default.ib
```

### Reference

[1] Kickstart Documentation  
<https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html>

[2] Anaconda Network Configuration  
<https://fedoraproject.org/wiki/Anaconda/Network>

[3] IPXE Configuration Settings  
<https://ipxe.org/settings>
