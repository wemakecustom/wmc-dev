Selenium Vagrant
================

A basic selenium with a Chrome driver is installed, listening on port 4444.

Port 4444 is forwarded from the host to the guest.

You should be able to see the hub on your host: http://localhost:4444/wd/hub/

The VM’s hostname is selenium.wemakecustom.com and its IP (10.10.10.11) is registered on the public DNS.

If needed, configure Behat to use http://selenium.wemakecustom.com:4444/wd/hub as `wd_host`.
