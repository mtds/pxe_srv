# Development

File                         | Description
-----------------------------|------------------------
[var/aliases/pxesrv.sh][08]  | Collection of shell functions used for development

Docker on localhost:

```bash
# start pxesrv ad docker service container instance
pxesrv-docker-container
# clean up all container artifacs of pxesrv
pxesrv-docker-container-remove
```

## Virtual Machines

Virtual machines on localhost are build with [vm-tools][12].

Bootstrap a VM instance and start pxesrv in foreground:

```bash
pxesrv-vm-service-debug
```

Bootstrap a VM instance and start `pxesrv` as Systemd service:

```
pxesrv-vm-service-systemd-unit
# check the service log
vm ex $PXESRV_VM_INSTANCE -r -- tail -f /var/log/pxesrv.log
```

Bootstrap a VM instance and start `pxesrv` in a docker container

```bash
pxesrv-vm-service-docker-container
```

Start a VM instance with PXE boot enable and connect to VNC

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



[08]: var/aliases/pxesrv.sh
[12]: https://github.com/vpenso/vm-tools "vm-tools home-page"
