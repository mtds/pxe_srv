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

Use [Qemu][03] to start a local VM with PXE boot enabled (cf. [var/aliases/qemu.sh][04]): 

```bash
# start a VM to PXE boot from the service
>>> vm-boot-pxe
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

Cf. [Qemu Network Emulation][02]

Altnernativly [host the pxesrv service itself in a virtual machine][05].

### Docker Container

Build a container image using the [Dockerfile](Dockerfile) in this repository:

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

[00]: http://ipxe.org "iPXE home-page"
[01]: http://sinatrarb.com/ "Sinatra home-page"
[02]: https://qemu.weilnetz.de/doc/qemu-doc.html#pcsys_005fnetwork "Qemu Network Emulation"
[03]: https://www.qemu.org/ "Qemu home-page"
[04]: var/aliases/qemu.sh 
[05]: docs/test.md
[09]: http://pykickstart.readthedocs.io "Kickstart documentation"
[10]: https://fedoraproject.org/wiki/Anaconda "Anaconda documentation"

