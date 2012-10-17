# virtualmaster-turnkey-import

### 9 steps to start fully prepared TurnKey image, ready-to-use solution www.turnkeylinux.org!

How-to and the script for import **TurnKey Linux** into www.virtualmaster.com.

## Install

#### Create server
1) Create virtual server with whatever image and turn it on.
#### Boot rescue
2) After complete boot shutdown and start "Boot rescue".

3) Remember root password and IP address your new server showed in pop-up console and close it.
#### Download script on your computer and run it on server
4) Download install script from this repository. Default is installed Wordpress. To change image read section **Other images by customizing install script**:

    wget --no-check-certificate https://raw.github.com/pulecp/virtualmaster-turnkey-import/master/install.sh

5) Now open terminal on your computer and run this, where x.x.x.x is IP address your server:
	
    ssh root@x.x.x.x 'sh -s' < install.sh

6) After ending ssh connection (terminal promt returns on your computer) go on website with your server and open "Console". Here only press "Enter" and close this pop-up console window.
#### Create your new image
7) Now create your template by "Save As Image" button on website. Give it some name and create it.
#### Create new server from image
8) On top of website click on My images, choose your new image and Create New Server by button on left side.
#### Enjoy TurnKey
9) Remember root password for login over ssh. Passwords to application (e.g. WordPress), MySQL and others you find in **/root/passwords.txt**.

## Other images
This example is for WordPress. Advanced can simply edit install script and **deploy all Turnkey Linux** images.
Editable part is highlighted in script by box from '#'.

## Why too much work
It's not possible to install anything in virtualization environment like on a classic architecture. We must adjust
the system to virtualization layer. Turnkey Linux helps us in this way providing "tarball" of the system prepared for
Xen hypervisor.

Nevertheless this is only begin of whole automatization of installation process. We must then edit this "tarball". From
renaming devices, over changing network configuration to generating new passwords. All changes are visible in install script.


## Requirements
Minimal RAM size: 256MB

