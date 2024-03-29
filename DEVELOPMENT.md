# Development

Files within this repository configuring the development environment:

Files                        | Description
-----------------------------|------------------------
[var/aliases/qemu.sh][04]    | Use Qemu to start a virtual machine with PXE boot
[var/aliases/ipxe.sh][07]    | Help function to download and build iPXE

## Localhost

Start the [`pxesrv`](pxesrv) daemon as foreground process:

```sh
$PXESRV_PATH/pxesrv -p $PXESRV_PORT
```

Build or download [iPXE][ip] from the offical web-page;

```sh
# install build dependencies, build iPXE, and install to $PXESRV_ROOT
ipxe-build-from-source
# ...or download iPXE from the offical source to $PXESRV_ROOT
ipxe-download
```

Use `ipxe.iso` as initial rootfs for a KVM VM instance:

```sh
# start the iPXE.iso in a kvm instance
ipxe-instance
# on iPXE interactive prompt...initialize the network
iPXE> dhcp
# query the PXESrv instance on localhost
iPXE> chain http://127.0.0.1:4567/redirect
```

[ip]: https://git.ipxe.org/ipxe.git

Use [Qemu][03] to start a local VM with PXE boot enabled 
( cf.[Qemu Network Emulation][02]). Connect to PXESrv 
instance running on localhost:

```sh
pxe-instance
# use ctrl-b to drop into the shell
# get an IP address
iPXE> dhcp
# 10.0.2.2 is the default gateway (aka the host)
iPXE> chain http://10.0.2.2:4567/redirect
# ...
# create a link to another iPXE boot configuration
>>> ln -s $PXESRV_ROOT/centos $PXESRV_ROOT/once/10.0.2.2
# note that the gateway address is the client host address also
```

## Virtual Machines

Use the [Vagrantfile](Vagrantfile) to start virtual machine instances...

```sh
vagrant up
# start PXESrv
vagrant ssh -- 'PXESRV_ROOT=/srv/pxesrv $PXESRV_PATH/pxesrv -p $PXESRV_PORT'
# ...using the Systemd unit
vagrant ssh -- sudo systemctl enable --now pxesrv.service
```

### Client

Start a VM instance with PXE boot enable and connect to VNC:

```
pxe-vm-instance lxdev01
# us the VM instance fore development/testing
vm r lxdev01 # delete the VM instance 
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
[12]: https://github.com/vpenso/vm-tools "vm-tools home-page"
