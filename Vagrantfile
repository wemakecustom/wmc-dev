# -*- mode: ruby -*-
# vi: set ft=ruby :

# vagrant plugin install vagrant-persistent-storage
# vagrant plugin install vagrant-nfs_guest

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

  config.persistent_storage.enabled = true
  config.persistent_storage.location = "data.vdi"
  config.persistent_storage.size = 51200
  config.persistent_storage.mountname = 'data'
  config.persistent_storage.filesystem = 'ext4'
  config.persistent_storage.mountpoint = '/media/data'
  config.persistent_storage.use_lvm = false

  config.ssh.forward_agent = true

  config.vm.synced_folder 'home', '/home/vagrant', type: 'nfs_guest'
  config.vm.synced_folder 'projects', '/media/data/projects', type: 'nfs_guest'
  config.vm.synced_folder '~', '/media/home', type: 'nfs'
  config.vm.synced_folder '~/Google Drive/WMC - Repository', '/home/vagrant/wmc-repository', type: 'nfs'

  config.vm.network :private_network, ip: "10.10.10.10"
  config.vm.network :public_network

  config.vm.provision :shell, :path => "setup/install.sh"
end
