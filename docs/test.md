This example uses a virtual machine setup with [vm-tools][01]:

```bash
# start a Debian Stretch virtual machine instance
vm s debian9 lxcm01
# prepare the VM
vm ex lxcm01 -r '
        # tools to use extra repository over HTTPS
        apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
        # add official Docker GPG keys
        curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        # set up the stable repository
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        # install components
        apt-get update && apt-get -y install git-core ruby-sinatra docker-ce
        # clone this repository
        git clone https://github.com/vpenso/pxesrv
        # load the repository environment on login
        echo "source $HOME/pxesrv/source_me.sh" >> $HOME/.bashrc
'
```

[01]: https://github.com/vpenso/vm-tools
