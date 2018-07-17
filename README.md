# Serving iPXE/pxelinux files over HTTP

This small Ruby script will use the Sinatra web framework to serve static files over HTTP.

The server will answer the following HTTP requests, everything else will throw an ``404`` error:
* [public/menu.ipxe](public/menu.ipxe): example iPXE configuration
* ``/IP``: this entry will be created on the fly only for specific purposes and will point to specific files with a symbolic link;
* ``/pxelinux.cfg/default``: default menu for a pxelinux config boot (for hosts which **does not** support iPXE);
* ``/pxelinux.cfg/:name``: pxelinux config boot customized as an ERB template.

* The server is designed to serve static files from a specific subfolder, defined in the configuration file.
* ``pxelinux`` configuration files should be under the ``pxelinux.cfg`` directory.

```bash
# start the service for development and testing
>>> PXESRV_LOG=/tmp/pxesrv.log PXESRV_ROOT=$PWD $PWD/pxesrv
# start a VM to PXE boot from the service
>>> vm-boot-pxe
# use ctrl-b to drop into the shell
# get an IP address
iPXE> dhcp
# 10.0.2.2 iss teh default gateway (aka the host)
iPXE> chain http://10.0.2.2:4567/menu
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
  public: /srv/pxesrv/static
  views: /srv/pxesrv/views
```

**NOTE**: YAML is sensible to indentation!! See the example file in the repo.


