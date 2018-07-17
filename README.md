# PXESrv

HTTP server redirecting client request based on links to a target response file.

Environment       | Description
------------------|---------------------------
PXESRV_ROOT       | Path to the HTTP server document root (i.e. [public/](public/))
PXESRV_LOG        | Path to the log file, defaults to `/var/log/pxesrv.log`

```bash
# load the environment from var/aliases/*.sh 
>>> source source_me.sh
# start the service for development and testing in foreground
>>> $PXESRV_PATH/pxesrv -p 4567
...
# start a VM to PXE boot from the service
>>> vm-boot-pxe
# use ctrl-b to drop into the shell
# get an IP address
iPXE> dhcp
# 10.0.2.2 is the default gateway (aka the host)
iPXE> chain http://10.0.2.2:4567/redirect
```

By default the response is redirected to [`$PXESRV_ROOT/default`](public/default) (i.e. a iPXE menu configuration). Unless a symbolic link in the directory `$PXESRV_ROOT/link/` called like the IP-address of the client node references another configuration.

```bash
>>> mkdir -p $PXESRV_ROOT/link ; \
    ln -s $PXESRV_ROOT/centos $PXESRV_ROOT/link/127.0.0.1
```





Build and run as a docker container:

```bash
# build a docker container image
docker build -t pxesrv $PWD
# start the container
docker run -d --name pxesrv --volume /srv/pxesrv:/srv/pxesrv pxesrv
```
