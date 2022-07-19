# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # sync the development repository to the VM
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/srv/pxesrv", type: "rsync", rsync__exclude: ".git/"

  # make sure to load the development repo...
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    echo "source /srv/pxesrv/source_me.sh" > /etc/profile.d/pxesrv.sh
    cp /srv/pxesrv/var/systemd/pxesrv.service /etc/systemd/system/
    ln -s /srv/pxesrv/pxesrv /usr/sbin/pxesrv
    systemctl daemon-reload
  SHELL

  # forward the PXESrv default port
  config.vm.network "forwarded_port", guest: 4567, host: 4567

  config.vm.define "el8" do |config|
    config.vm.hostname = "el8"
    config.vm.box = "almalinux/8"

    # install Ruby Sinatra...
    config.vm.provision "shell", privileged: true , inline: <<-SHELL
      dnf install -y ruby
      gem install sinatra
    SHELL
  end

end
