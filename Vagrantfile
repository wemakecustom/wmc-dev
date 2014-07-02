# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "trusty32"  #Box Name
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box" #Box Location
  config.vm.hostname = 'dev.wemakecustom.com'

  config.vm.provider :virtualbox do |virtualbox|
    # virtualbox.gui = true  # Uncomment to start the VM with the GUI
    virtualbox.name = "wmc-dev"
    virtualbox.customize ["modifyvm", :id, "--ioapic", "on"]
    virtualbox.memory = 2048
    virtualbox.cpus = 2
  end

  config.ssh.forward_agent = true

  config.vm.network :private_network, ip: "10.10.10.10"

  #config.vm.network :public_network

  config.vm.provision :shell, :path => "setup/install.sh"

  config.vm.synced_folder "projects", "/home/vagrant/projects", :nfs => true
end
