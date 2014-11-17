WeMakeCustom Dev Environment
===========================================


## Installation

 1. `git clone git@github.com:wemakecustom/wmc-dev.git ~/Sites/wmc`
 2. `cd ~/Sites/wmc`
 3. `mkdir projects` (Vagrant /media/data/projects directory will be mounted there)
 3. `mkdir home` (Vagrant home directory will be mounted there)

### Using Vagrant

 1. Activate in your Bios/EFI if not Intel vt/Amd-v 
 2. `sudo ./setup/vagrant-host.sh`
 3. `vagrant up`

### Using native Linux

 1. Change hostname (optional)
   1. `echo 'dev' | sudo tee /etc/hostname`
   2. `sudo nano /etc/hosts` (Replace ubuntu or whatever hostname by `dev.wemakecustom.com dev`)
   3. `sudo hostname -F /etc/hostname`
 2. `sudo rsync -av setup/files/ /`
 3. `sudo ./setup/install.sh`
 4. `sudo ./setup/install-native-ubuntu.sh`
 5. `ln -sv "${HOME}/Sites/wmc/projects" "${HOME}/wmc-projects"` (`~/wmc-projects` must exists)
 6. `ln -sv "${HOME}/Google Drive/WMC - Repository" "${HOME}/wmc-repository"` (`~/wmc-repository` must exists)

## Final configuration

 1. Move your projects in the projects folder, [respecting the hierarchy](#projects-hierarchy).
 2. Install LastPass: `setup/install-lastpass.sh`
 3. Run the configure script ([`setup/configure.sh`](setup/configure.sh)) to personalize. On Vagrant: `/vagrant/setup/configure.sh`.

## Other information

### Networking

[setup/files/etc/apache2/sites-available/wmc.conf](Apache is configured) to use dev.wemakecustom.com as host.

Your [Vagrantfile](Vagrant has a private IP) of `10.10.10.10`.
A public DNS pointing `*.dev.wemakecustom.com` to it already exists.
You may add a public network so your Vagrant will appear on the network, but this is a security risk.

[DNSmasq is configured](setup/files/etc/dnsmasq.d/wmc) so `*.dev.wemakecustom.com` points to `127.0.0.1`

### Common vagrant commands

Useful commands:

    vagrant help          Get help
    vagrant up            Starts and provisions the vagrant environment
    vagrant halt          Stops the vagrant machine
    vagrant ssh           Connects to machine via SSH

If your Vagrant does not boot, try uncommenting `virtualbox.gui = true` to see the console.

### SSH config

Instead of using `vagrant ssh` you may add an alias on your local machine:

```bash
vagrant ssh-config --host wmc-dev >> ~/.ssh/config
```

And then, you may simply `ssh wmc-dev`.

### Projects hierarchy

The file structure is `./projects/CLIENT/PROJECT` and it translates to http://PROJECT.CLIENT.dev.wemakecustom.com/

Going to http://list.dev.wemakecustom.com/ will provide a list of existing clients/projects.

### Project files via NFS

Vagrant will create a disk in `./data.vdi` and mount it on `/media/data`.
This data will survive even if the VM is destroyed.

All your projects will be stored in `/media/data/projects`, symlinked to `~/wmc-projects`, in turn symlinked to `/var/www/wmc` and exported via NFS.
Vagrant will also mount it in `./projects` so you can access it locally.

`~/Google Drive/WMC - Repository` is symlinked (or shared via NFS) to `~/wmc-projects`, this is the shared assets

### MySQL & phpMyAdmin

    User : root
    Password : root
    http://dev.wemakecustom.com/phpmyadmin/ (Vagrant host autologins)

MySQL data is stored on /media/data/mysql.
This data will survive even if the VM is destroyed.
