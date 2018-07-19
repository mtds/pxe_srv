This example uses a virtual machine setup with [vm-tools][01]:

```bash
# start a Debian Stretch virtual machine instance
vm s debian9 lxcm01
# install prerequisites
vm ex lxcm01 -r -- apt -y install git-core ruby-sinatra
# rsync this repo into the VMs /opt
vm sy lxcm01 -r $PXESRV_PATH :/opt
# add the repo to the login environment
vm ex lxcm01 -r 'echo "source /opt/pxesrv/source_me.sh" >> $HOME/.bashrc'
```

Start the pxesrv service in the VM:

```bash
# start the service in foreground
vm ex lxcm01 -r \$PXESRV_PATH/pxesrv
# ...alternativly...
# use systemd to start the service
vm ex lxcm01 -r '
        # install the service unit file
        cp $PXESRV_PATH/var/systemd/pxesrv.service /etc/systemd/system/
        systemctl daemon-reload
        # link to the document root within this repo
        ln -s $PXESRV_ROOT /srv/pxesrv
        systemctl enable --now pxesrv
'
# ...alternativly...
# start a service container
vm ex lxcm01 -r '
        # tools to use extra repository over HTTPS
        apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
        # add official Docker GPG keys
        curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        # set up the stable repository
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        # install components
        apt-get update && apt-get -y install docker-ce
        # build and run the pxesrv service container
        pxesrv-docker-container
'
```

PXE boot a client VM instance:

```bash
# define and start a VM instance 
vm s debian9 lxdev01
# configure a VM instance for PXE boot with VNC support
vm co lxdev01 -NOv -M 2
# stop, redefine, start VM instance
vm sh lxdev01 && vm re lxdev01 && vm st lxsdev01
# open VNC console
vm v lxdev01 &
# redirect request to kickstart the VM instance
vm ex lxcm01 -r "
        mkdir \$PXESRV_ROOT/link
        ln -s \$PXESRV_ROOT/centos \$PXESRV_ROOT/link/$(vm ip lxdev01)
"
```

Chainload the configuration from the iPXE shell:

```bash
# use ctrl-b to drop into the shell
# get an IP address
iPXE> dhcp
# the boot service is running on lxcm01, 10.1.1.7
iPXE> chain http://10.1.1.7:4567/redirect
```


[01]: https://github.com/vpenso/vm-tools
