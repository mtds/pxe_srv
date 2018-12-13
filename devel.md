# Development

Files                        | Description
-----------------------------|------------------------
[var/aliases/qemu.sh][04]    | Use Qemu to start a virtual machine with PXE boot
[var/aliases/pxesrv.sh][08]  | Help functions to bootstrap a PXESrv service in various configurations
[var/aliases/ipxe.sh][07]    | Help function to build iPXE

Download, build and use a custom iPXE version with shell functions defined in [var/aliases/ipxe.sh][07].

## Docker Container

Use Docker on localhost to start the PXESrv container:

```bash
# start pxesrv ad docker service container instance
pxesrv-docker-container
# clean up all container artifacs of pxesrv
pxesrv-docker-container-remove
```

Use [Qemu][03] to start a local VM with PXE boot enabled 
( cf.[Qemu Network Emulation][02]). Connect ot PXESrv 
instance running on localhost:

```bash
>>> pxe-qemu-instance
# use ctrl-b to drop into the shell
# get an IP address
iPXE> dhcp
# 10.0.2.2 is the default gateway (aka the host)
iPXE> chain http://10.0.2.2:4567/redirect
# ...
# create a link to another iPXE boot configuration
>>> mkdir -p $PXESRV_ROOT/link ; \
    ln -s $PXESRV_ROOT/centos $PXESRV_ROOT/link/10.0.2.2
# note that the gateway address is the client host address also
```

## Virtual Machines

Virtual machines on localhost are build with [vm-tools][12].

### PXESrv Service

Bootstrap a VM instance and start pxesrv in **foreground**:

```bash
pxesrv-vm-instance-debug
```

Bootstrap a VM instance and start `pxesrv` as **Systemd service**:

```
pxesrv-vm-instance-systemd-unit
# check the service log
vm ex $PXESRV_VM_INSTANCE -r -- tail -f /var/log/pxesrv.log
```

Bootstrap a VM instance and start `pxesrv` in a **Docker container**:

```bash
pxesrv-vm-instance-docker-container
```

### PXE Client


Start a VM instance with PXE boot enable and connect to VNC (cf. [vm-tools][12])

```
pxe-vm-instance
```

Use **ctrl-b** to access the iPXE shell.

```bash
# start the network interface
dhcp
# query the PXESrv boot server
chain http://lxcm02.devops.test:4567/redirect
```



[02]: https://qemu.weilnetz.de/doc/qemu-doc.html#pcsys_005fnetwork "Qemu Network Emulation"
[03]: https://www.qemu.org/ "Qemu home-page"
[04]: var/aliases/qemu.sh
[07]: var/aliases/ipxe.sh
[08]: var/aliases/pxesrv.sh
[12]: https://github.com/vpenso/vm-tools "vm-tools home-page"
