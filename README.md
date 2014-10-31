WeMakeCustom Dev Environment
===========================================


## Installation

 1. `git clone git@github.com:wemakecustom/wmc-dev.git ~/Sites/wmc`
 2. `cd ~/Sites/wmc`
 3. `mkdir projects`

### Using Vagrant

 1. Activate in your Bios/EFI if not Intel vt/Amd-v 
 2. `sudo ./setup/vagrant-host.sh`
 3. `vagrant up`

### Using native Linux

 1. `sudo -av rsync -av setup/files/ /`
 2. `sudo ./setup/install.sh`
 3. `sudo ln -sv ~/Sites/wmc/projects /var/www/wmc`
 3. More infos coming soon.

And:

 1. Move your projects in the projects folder, [respecting the hierarchy](#projects-hierarchy).
 2. On the vagrant, run the configure script to personalize: `/vagrant/setup/configure.sh`.

## Projects hierarchy

The file structure is `./projects/CLIENT/PROJECT` and it translates to http://PROJECT.CLIENT.dev.wemakecustom.com/

## Project files via NFS

Vagrant will create a disk in `./data.vdi` and mount it on `/media/data`.
This disk will survive even if the VM is destroyed.

All your projects will be stored in `/media/data/projects`, symlinked to `/var/www/wmc` and exported via NFS.
Vagrant will also mount it in `./projects` so you can access it locally.

## MySQL & phpMyAdmin
    http://dev.wemakecustom.com/phpmyadmin/
    Login : root
    Password : root

## Using your Vagrant

    vagrant help          Get help
    vagrant up            Starts and provisions the vagrant environment
    vagrant halt          Stops the vagrant machine
    vagrant ssh           Connects to machine via SSH

## SSH config

Instead of using `vagrant ssh` you may add an alias on your local machine:

```bash
vagrant ssh-config --host wmc-dev >> ~/.ssh/config
```

And then, you may simply `ssh wmc-dev`.
