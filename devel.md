## Development

File                         | Description
-----------------------------|------------------------
[var/aliases/pxesrv.sh][08]  | Collection of shell functions used for development

Docker localhost:

```bash
# start pxesrv ad docker service container instance
pxesrv-docker-container
# clean up all container artifacs of pxesrv
pxesrv-docker-container-remove
```

Virtual machines on localhost (cf. [vm-tools][12]):

```bash
# bootstrap a VM instance and start pxesrv in foreground
pxesrv-vm-service-debug
# boostrap a VM instance and start pxesrv with systemd
pxesrv-vm-service-systemd-unit
# boostrap a VM instance and start pxesrv in a docker container
pxesrv-vm-service-docker-container
# start a VM instance with PXE boot enable and connect to VNC
pxesrv-vm-client-pxe-boot
```

[08]: var/aliases/pxesrv.sh
[12]: https://github.com/vpenso/vm-tools "vm-tools home-page"
