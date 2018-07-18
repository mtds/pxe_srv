This example uses a virtual machine setup with [vm-tools][01]:

```bash
# start a Debian Stretch virtual machine instance
vm s debian9 lxcm01
# installe prerequisites
vm ex lxcm01 -r '
        # tools to use extra repository over HTTPS
        apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
        # add official Docker GPG keys
        curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        # set up the stable repository
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        # install components
        apt-get update && apt-get -y install git-core ruby-sinatra docker-ce
'
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
vm ex lxcm01 -r pxesrv-docker-container
```

[01]: https://github.com/vpenso/vm-tools
