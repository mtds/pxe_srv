This example uses a virtual machine setup with [vm-tools][01]:


```bash
# start a CentOS 7 virtual machine instance
vm s centos7 lxcm01
# prepare the VM
vm ex lxcm01 -r '
        # diable the firewall
        systemctl disable --now firewalld
        # install Git
        yum install -q -y epel-release
        yum install -q -y docker git bash-completion
        # clone this repository
        git clone https://github.com/vpenso/pxesrv
        # load the repository environment on login
        echo "source $HOME/pxesrv/source_me.sh" >> $HOME/.bashrc
'
```

[01]: https://github.com/vpenso/vm-tools
