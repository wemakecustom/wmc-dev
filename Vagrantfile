# -*- mode: ruby -*-
# vi: set ft=ruby :

require './setup/vagrant-provision-reboot/vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|
  config.vm.box = "trusty32"  #Box Name
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box" #Box Location

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.synced_folder ".", "/media/vagrant", :nfs => true

  config.vm.network :private_network, ip: "10.10.10.10"

  #config.vm.network :public_network

  config.vm.provision :shell, :path => "setup/dist-upgrade.sh"

  #config.vm.provision :unix_reboot

  config.vm.provision :shell, :path => "setup/install.sh"

end
