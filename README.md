# PXESrv

HTTP server redirecting client request based on links to a target response file.

Environment       | Description
------------------|---------------------------
PXESRV_ROOT       | Path to the HTTP server document root (i.e. [public/](public/))
PXESRV_LOG        | Path to the log file, defaults to `/var/log/pxesrv.log`
PXESRV_CONF       | Optional path to the PXESrv configuration file

```bash
>>> source source_me.sh
PXESRV_ROOT=/srv/projects/pxe_srv/public
PXESRV_LOG=/tmp/pxesrv.log
# start the service for development and testing in foreground
>>> $PXESRV_PATH/pxesrv
...
# start a VM to PXE boot from the service
>>> vm-boot-pxe
# use ctrl-b to drop into the shell
# get an IP address
iPXE> dhcp
# 10.0.2.2 iss teh default gateway (aka the host)
iPXE> chain http://10.0.2.2:4567/redirect
```

By default the response is redirected to [$PXESRV_ROOT/default](public/default) (i.e. a iPXE menu configuration). Unless a symbolic link in the directory `$PXESRV_ROOT/link/` called like the IP-address of the client node references another configuration.

```bash
>>> ln -s $PXESRV_ROOT/centos $PXESRV_ROOT/link/127.0.0.1
```





Build and run as a docker container:

```bash
# build a docker container image
docker build -t pxesrv $PWD
# start the container
docker run -d --name pxesrv --volume /srv/pxesrv:/srv/pxesrv pxesrv
```


### Serve iPXE files

* Define the DHCP option ``filename`` as follows: ``http://myserver:myport/menu``
* Whenever a booting node will contact this server with the previos request, it will receive by **default** a ``menu.ipxe`` file.

In case the node needs to grab a specific iPXE file then you should do the following:
1. create a symbolic link (in the form of IP address of the booting node) pointing to a specific iPXE file.
2. once the node is rebooted it will contact the Sinatra server, which will verify if the node IP is matching the symbolic link.
3. if the match is correct, then we will serve a iPXE file.
4. otherwise the Sinatra server will serve a default menu file.

There's an **helper script** available, called `create_symlink.rb` which will help to create as many symlinks as necessary.  
It can be used in combination to ``nodeset`` (part of ``clustershell``) in the following way:
```
nodeset --expand node[1-4].mydomain | ruby create_symlink.rb -f /some/file.ipxe
```
References:
* [Nodeset](https://clustershell.readthedocs.io/en/latest/tools/nodeset.html)

## Configuration File

It's in YAML format. An example:
```
config:
  public: /srv/pxesrv/public
  views: /srv/pxesrv/views
```

**NOTE**: YAML is sensible to indentation!! See the example file in the repo.


