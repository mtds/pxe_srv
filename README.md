# PXESrv

PXESrv is a [Sinatra][01] HTTP server hosting [iPXE][00] network boot configurations to:

* Boot all clients from a **default boot configuration** (boot menu for interactive installers).
* **Redirect a single time** (once) to a desired boot configuration.
  - Boot into **interactive OS installers**  like [CentOS Anaconda][10] or [Debian Installer](https://www.debian.org/releases/stable/amd64/index.html.en)
  - Boot into **automatic provisioning** like [CentOS Kickstart][09] or [Debian Preseed](https://wiki.debian.org/DebianInstaller/Preseed)
  - Forward to a **provisioning services** like [FAI](http://fai-project.org/) or [Cobbler](http://cobbler.github.io/)
* Persistently boot a client specific **static redirect** boot configuration:
  - Chainload external (third party) boot configurations, or provisioning systems like [Foreman][tf] or CoreOS [Matchbox][mb]
  - Boot stateless, immutable live-systems with [initramfs][ir] and [OverlayFS][of] (to the node main memory (RAM)) 

[tf]: https://www.theforeman.org/
[mb]: https://github.com/coreos/matchbox
[ir]: https://en.wikipedia.org/wiki/Initial_ramdisk
[of]: https://en.wikipedia.org/wiki/OverlayFS

PXESrv serves a configuration file, from its document root directory, which is read from a POSIX file-system:

* The configuration can be altered creating/editing files in a directory tree (eventually via remote login [SSH][ss], [Clustershell][cs]).
* Easy integration with configuration management systems like [Chef][ch], [Puppet][pp], [CFengine][cf], [Ansible][an], [SaltStack][sl].

[an]: https://www.ansible.com/
[cf]: https://cfengine.com/
[ch]: https://www.chef.io
[cs]: http://cea-hpc.github.io/clustershell
[pp]: https://puppet.com
[sl]: https://www.saltstack.com/
[ss]: https://www.ssh.com/ssh

### Motivation

Why using this tool? PXEsrv can be useful in environments where (for whatever reason):

* it's not possible to use external resources (e.g. like those located on big cloud providers like AWS, MS Azure, Google Cloud Platform, etc.);
* ready-made provisioning solutions from external parties (be them open source or commercial software) cannot be purchased or easily adopted.

**PXEsrv** can be easily integrated on an existing infrastructure when the following services are __already__ in place:

* DNS  (e.g. [ISC BIND](https://www.isc.org/downloads/bind/))
* DHCP (e.g [ISC DHCP](https://www.isc.org/downloads/dhcp/))
* HW support for PXE booting
* IP Management (optional) (e.g. [ONA](https://github.com/opennetadmin/ona), [NetBox from DigitalOcean](https://github.com/digitalocean/netbox), etc.)

The DHCP server must be able to provide an option with the location for network booting (AKA the ``filename`` option), which will then be used to point to the server/virtual machine/container where PXEsrv is running:

``` # An entry from ISC DHCP

host 10.10.10.1 {
    fixed-address 10.10.10.1;
    hardware ethernet 00:AA:BB:CC:DD:EE;
    option host-name "myhost";
    [...]
    filename "http://mysrv.domain:4567/";
}
```

Once the node to be installed is able to contact PXEsrv, the process will proceed from there and it's up to the admins decide if an interactive installation or an automatic provisioning system should be started.

PXEsrv strives to follow the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle): do a single thing (provides network boot configurations) in the most simple possible way and leave the rest (installation, configuration, etc.) to other tools.

### Prerequisites

The shell script ↴ [source_me.sh](source_me.sh) adds the tool-chain in this repository to your shell environment:

```bash
# load the environment from var/aliases/*.sh 
source source_me.sh && env | grep ^PXESRV
```

Install [Sinatra][si] on the hosting node:

```bash
# install dependencies on Debian
apt install -y ruby-sinatra
# install dependencies on CentOS
yum install -y rubygem-sinatra
```

[si]: https://github.com/sinatra/sinatra

## PXESrv Service Daemon 

**Environment variables** for the PXESrv service daemon:

Environment       | Description
------------------|---------------------------
PXESRV_ROOT       | Path to the HTTP server **document root** (i.e. [public/](public/))
PXESRV_LOG        | Path to the **log file**, defaults to `/var/log/pxesrv.log`

**Start the ↴ **[`pxesrv`](pxesrv)** service deamon**

```bash
# start the service for development and testing in foreground
$PXESRV_PATH/pxesrv -p 4567
```

### Usage

By default the **response to all clients `/redirect` requests** is

[`$PXESRV_ROOT/default`](public/default) 

unless a configuration in the directories

[`$PXESRV_ROOT/once/`](public/once/) (symbolic links)  
[`$PXESRV_ROOT/static/`](public/static/) 

called like the **IP-address of the client** node references another boot configuration.

Path                   | Description
-----------------------|------------------------
/redirect              | **Entry path for all client requests**
/default               | Default response path, unless a client has a specific boot configuration
/once/{client-ip}      | Redirect a client once to a linked boot configuration
/static/{client-ip}    | Redirect a client to a specific static boot configuration

### Configuration

The sub-directory ↴ [`public/`](public/), aka `$PXESRV_ROOT` contains an example iPXE configuration.

Reference examples in [centos/README.md](public/centos/README.md) or [debian/README.md](public/debian/README.md) illustrate installation with Anaconda/Kickstart or Debain-Installer/Pressed respectively.

### Development

Please refer to [DEVELOPMENT.md](DEVELOPMENT.md) for detailed instructions.

The document referenced above will also help to setup a test-environment in order to get fammiliar with the service.

## Deployment

Currently no packages are build for any Linux distribution.

Deployment is possible from this repository or with a [Docker][dk] container.

[dk]: https://www.docker.com/

### Systemd Unit

File                             | Description
---------------------------------|------------------------
[var/systemd/pxesrv.service][06] | Example PXESrv systemd service unit file

Use a [systemd service unit][11] to manage the `pxesrv` daemon:

```bash
# link to the service executable (expected by the systemd unit)
ln -s $PXESRV_PATH/pxesrv /usr/sbin/pxesrv
# install the service unit file
cp $PXESRV_PATH/var/systemd/pxesrv.service /etc/systemd/system/
systemctl daemon-reload
# link to the document root within this repo
ln -s $PXESRV_ROOT /srv/pxesrv
# start the PXESrv using Systemd
systemctl enable --now pxesrv
```

### Docker Container

File                      | Description
--------------------------|------------------------
[Dockerfile](Dockerfile)  | Example Docker file to build a PXESrv image

Build a PXESrv Docker container and start it:

```bash
# build a docker container image
buildah build -f Dockerfile -t pxesrv
# start the container
podman run --rm \
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
