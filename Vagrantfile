# -*- mode: ruby -*-
# vi: set ft=ruby :

file_to_disk = File.dirname(__FILE__) + '/data.vdi'

Vagrant.configure("2") do |config|
  config.vm.box = "trusty32"  #Box Name
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box" #Box Location
  config.vm.hostname = 'dev.wemakecustom.com'

  # https://github.com/kusnier/vagrant-persistent-storage
  # vagrant plugin install vagrant-persistent-storage
  config.persistent_storage.enabled = true
  config.persistent_storage.location = file_to_disk
  config.persistent_storage.size = 50000
  config.persistent_storage.mountname = 'data'
  config.persistent_storage.filesystem = 'ext4'
  config.persistent_storage.mountpoint = '/media/data'
  config.persistent_storage.volgroupname = 'vg_data'

  config.vm.provider :virtualbox do |virtualbox|
    # Uncomment to start the VM with the GUI
    # virtualbox.gui = true
    virtualbox.name = "wmc-dev"
    virtualbox.customize ["modifyvm", :id, "--ioapic", "on"]
    virtualbox.memory = 2048
    virtualbox.cpus = 2
  end

  config.ssh.forward_agent = true

  config.vm.network :private_network, ip: "10.10.10.10"

  #config.vm.network :public_network

  config.vm.provision :shell, :path => "setup/install.sh"

  config.vm.provision :host_shell do |host_shell|
    host_shell.inline = '[ -d projects ] || mkdir projects; mount | grep -qF dev.wemakecustom.com || sudo mount dev.wemakecustom.com:/media/data/projects projects'
  end

end
