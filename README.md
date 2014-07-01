WeMakeCustom Vagrant
===========================================


## Installation

Installation is a quick 3 step process:

1. git init
2. git clone git@github.com:wemakecustom/vagrant-dev.git
3. sudo ./setup/system.sh
4. [Mount projects via NFS](#Mount projects via NFS)
4. Move your projects in the projects folder. Please respect the following path : ./projects/client/project

## Vagrant common command

     vagrant help          Get help

## MySQL & phpMyAdmin
    http://dev.wemakecustom.com/phpmyadmin/
    Login : root
    Password : root

## Mount projects via NFS

Vagrant will create a disk in `./data.vdi` and mount it on `/media/data`.
This disk will survive even if the VM is destroyed.

All your projects will be stored in `/media/data/projects`, symlinked to `/var/www/wmc` and exported via NFS.
To access your files via your computer, you must mount it using NFS:

```bash
[ -d projects ] || mkdir projects && mount dev.wemakecustom.com:/media/data/projects projects
```
