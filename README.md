# PXESrv

PXESrv is a [Sinatra][01] HTTP server hosting [iPXE][00] network boot configurations used to:

* Boot into **interactive OS installers**  like [CentOS Anaconda][10] or [Debian Installer](https://www.debian.org/releases/stable/amd64/index.html.en)
* Boot into **automatic provisioning** like [CentOS Kickstart][09] or [Debian Preseed](https://wiki.debian.org/DebianInstaller/Preseed)
* **Redirect to provisioning services** like [FAI](http://fai-project.org/) or [Cobbler](http://cobbler.github.io/)

This service **redirects incomming client request once to a desired boot configuration**. 

The sub-directory ↴ **[`public/`](public/) contains an example iPXE configuration**.

### Service Deamon 

```bash
# install dependencies on Debian
apt install -y ruby-sinatra
# install dependencies on CentOS
yum install -y rubygem-sinatra
```

**Environment variables** for the pxesrv service daemon:

Environment       | Description
------------------|---------------------------
PXESRV_ROOT       | Path to the HTTP server **document root** (i.e. [public/](public/))
PXESRV_LOG        | Path to the **log file**, defaults to `/var/log/pxesrv.log`

The shell script ↴ [source_me.sh](source_me.sh) adds the tool-chain in this repository to your shell environment:

```bash
# load the environment from var/aliases/*.sh 
source source_me.sh && env | grep ^PXESRV
```

**Start the ↴ **[`pxesrv`](pxesrv)** service deamon**

```bash
# start the service for development and testing in foreground
$PXESRV_PATH/pxesrv -p 4567
```

By default the **response to all clients `/redirect` requests** is [`$PXESRV_ROOT/default`](public/default) (i.e. a iPXE menu configuration). Unless a symbolic link in the directory `$PXESRV_ROOT/link/` called like the **IP-address of the client node references another boot configuration**.

Path            | Description
----------------|------------------------
/redirect       | Entry path for all client requests
/default        | Default response path, unless a client has a configuration in `$PXESRV_ROOT/link/`

### Systemd Unit

File                             | Description
---------------------------------|------------------------
[var/systemd/pxesrv.service][06] | Example PXESrv systemd service unit file

Use a [systemd service unit][11] to manage the `pxesrv` daemon:

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
[Dockerfile](Dockerfile)  | Example Docker file to build a PXESrv image

Build a PXESrv Docker container and start it:

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
[05]: docs/test.md
[06]: var/systemd/pxesrv.service
[08]: var/aliases/pxesrv.sh
[09]: http://pykickstart.readthedocs.io "Kickstart documentation"
[10]: https://fedoraproject.org/wiki/Anaconda "Anaconda documentation"
[11]: https://www.freedesktop.org/software/systemd/man/systemd.service.html
[12]: https://github.com/vpenso/vm-tools "vm-tools home-page"
