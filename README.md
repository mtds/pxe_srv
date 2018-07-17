# PXESrv

**[pxesrv](pxesrv)** is a [Sinatra][01] based HTTP server redirecting client request based on links to a target response file.

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

By default the response to all clients is redirected to [`$PXESRV_ROOT/default`](public/default) (i.e. a iPXE menu configuration). Unless a symbolic link in the directory `$PXESRV_ROOT/link/` called like the IP-address of the client node references another configuration file.

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
    ln -s $PXESRV_ROOT/centos $PXESRV_ROOT/link/127.0.0.1
# ...
```

Cf. [Qemu Network Emulation][02]

### Docker Container

Build a container image using the [Dockerfile](Dockerfile) in this repository:

```bash
# build a docker container image
docker build -t pxesrv $PXESRV_PATH
# start the container
docker run --rm \
           --detach \
           -it \
           --name pxesrv \
           --publish 4567:4567 \
           --volume $PXESRV_ROOT:/srv/pxesrv \
       pxesrv
```

[01]: http://sinatrarb.com/ "Sinatra home-page"
[02]: https://qemu.weilnetz.de/doc/qemu-doc.html#pcsys_005fnetwork "Qemu Network Emulation"
