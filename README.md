# Serving iPXE/pxelinux files over HTTP

This small Ruby script will use the Sinatra web framework to serve static files over HTTP.

The server will answer the following HTTP requests, everything else will throw an ``404`` error:
* ``/menu``: corresponds to an IPXE config file (``menu.ipxe``);
* ``/IP``: this entry will be created on the fly only for specific purposes and will point to specific files with a symbolic link;
* ``/pxelinux.cfg/default``: default menu for a pxelinux config boot (for hosts which **does not** support iPXE);
* ``/pxelinux.cfg/:name``: pxelinux config boot customized as an ERB template.

* The server is designed to serve static files from a specific subfolder, defined in the configuration file.
* ``pxelinux`` configuration files should be under the ``pxelinux.cfg`` directory.

```bash
# build a docker container image
docker build -t pxesrv .
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
  public: /srv/pxe_srv/static
  views: /srv/pxe_srv/views
```

**NOTE**: YAML is sensible to indentation!! See the example file in the repo.


