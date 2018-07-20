# PXESrv

**[pxesrv](pxesrv)** is a [Sinatra][01] HTTP server hosting [iPXE][00] network boot configurations used to:

* Boot **stateless live systems**
* Boot into **interactive OS installers** (i.e. [Anaconda][10])
* Boot into **automatic provisioning** (i.e. [Kickstart][09])

Path            | Description
----------------|------------------------
/redirect       | Entry path for all client requests
/default        | Default response path, unless a client has a configuration in `$PXESRV_ROOT/link/`

By default the response to all clients redirect requests is [`$PXESRV_ROOT/default`](public/default) (i.e. a iPXE menu configuration). Unless a symbolic link in the directory `$PXESRV_ROOT/link/` called like the IP-address of the client node references another boot configuration. 

Environment variables for the pxesrv service daemon:

Environment       | Description
------------------|---------------------------
PXESRV_ROOT       | Path to the HTTP server document root (i.e. [public/](public/))
PXESRV_LOG        | Path to the log file, defaults to `/var/log/pxesrv.log`

```bash
# load the environment from var/aliases/*.sh 
>>> source source_me.sh && env | grep ^PXESRV
# start the service for development and testing in foreground
>>> $PXESRV_PATH/pxesrv -p 4567
```

Use [Qemu][03] to start a local VM with PXE boot enabled (cf. [var/aliases/qemu.sh][04], and [Qemu Network Emulation][02]):

```bash
>>> qemu-boot-pxe
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

Download, build and use a custom iPXE version with shell functions defined in [var/aliases/ipxe.sh][07].

### Systemd Unit

File                 | Description
---------------------|------------------------
[pxesrv.service][06] | Example pxesrv systemd service unit file

Use a [systemd service unit][11] to manage the pxesrv daemon:

```bash
# install the service unit file
cp $PXESRV_PATH/var/systemd/pxesrv.service /etc/systemd/system/
systemctl daemon-reload
# link to the document root within this repo
ln -s $PXESRV_ROOT /srv/pxesrv
systemctl enable --now pxesrv
```

### Docker Container

File                      | Description
--------------------------|------------------------
[Dockerfile](Dockerfile)  | Example Docker file to build a pxesrv image

Build a pxesrv Docker container and run i:

```bash
# build a docker container image
docker build -t pxesrv $PXESRV_PATH
# start the container
docker run --rm \
           --detach \
           --interactive \
           --tty \
           --name pxesrv \
           --publish 4567:4567 \
           --volume $PXESRV_ROOT:/srv/pxesrv \
       pxesrv
```

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


[00]: http://ipxe.org "iPXE home-page"
[01]: http://sinatrarb.com/ "Sinatra home-page"
[02]: https://qemu.weilnetz.de/doc/qemu-doc.html#pcsys_005fnetwork "Qemu Network Emulation"
[03]: https://www.qemu.org/ "Qemu home-page"
[04]: var/aliases/qemu.sh 
[05]: docs/test.md
[06]: var/systemd/pxesrv.service
[07]: var/aliases/ipxe.sh
[08]: var/aliases/pxesrv.sh
[09]: http://pykickstart.readthedocs.io "Kickstart documentation"
[10]: https://fedoraproject.org/wiki/Anaconda "Anaconda documentation"
[11]: https://www.freedesktop.org/software/systemd/man/systemd.service.html
[12]: https://github.com/vpenso/vm-tools "vm-tools home-page"
