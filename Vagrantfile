# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 5533, host: 5533
#  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.synced_folder ".", "/home/vagrant/Application"
  config.vm.synced_folder "../SuperGLU", "/home/vagrant/SuperGLU"
  config.vm.synced_folder "../GLUDB", "/home/vagrant/GLUDB"
#  config.vm.synced_folder "../icalendar", "/home/vagrant/icalendar"
#  config.vm.synced_folder "../pytz-2016.4", "/home/vagrant/pytz-2016.4"
#  config.vm.synced_folder "../python-dateutil-2.0", "/home/vagrant/python-dateutil-2.0"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
  end
  config.vm.provision "shell", privileged: false, path: ".provisioning_script.sh"
end
