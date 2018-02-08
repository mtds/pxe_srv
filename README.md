# Serving iPXE/pxelinux files over HTTP

This small Ruby script will use the Sinatra web framework to serve static files over HTTP.

The server will answer the following HTTP requests, everything else will throw an error:
* ``/menu``: corresponds to an IPXE config file;
* ``/hostname.fqdn``: this entry will be created on the fly only for specific purpose and will point to specific files with a symbolic link;
* ``/pxelinux.cfg/default``: default menu for a pxelinux config boot (for hosts which **does not** support iPXE);
* ``/pxelinux.cfg/:name``: pxelinux config boot customized as an ERB template.

## Workflow

The server is designed to serve static files from a specific subfolder, defined in the configuration file. ``pxelinux`` configuration files should be under the ``pxelinux.cfg`` directory.

### Node reinstallation with iPXE
1. use ``nodeset`` + bash script to create a bunch of symbolic links pointing to a specific iPXE file.
2. once the node is rebooted it will contact the Sinatra server, which will verify if the node hostname is matching the symbolic link.
3. if the match is correct, then we will serve a tailored iPXE file.
4. otherwise the Sinatra server will serve a default file.

## Configuration File

It's in YAML format. An example:
```
SrvConfig:
  public_dir: /srv/pxe_srv/static
  views: /srv/pxe_srv/views
```

**NOTE**: YAML is sensible to indentation!! See the example file in the repo.

