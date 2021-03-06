# virtualmaster-turnkey-import

### 9 steps to start fully prepared TurnKey image, ready-to-use solution www.turnkeylinux.org!

How-to and the script for import **TurnKey Linux** into www.virtualmaster.com. 

## Install

#### Create server
1) Create virtual server with whatever image and turn it on.
#### Boot rescue
2) After complete boot "Shutdown" and start "Boot rescue".

3) Remember root password and IP address your new server showed in pop-up console and close it.
#### Download script on your computer and run it on server
4) Download install script from this repository. Default will be installed Wordpress. To change image read section **Other images by customizing install script**:

    wget --no-check-certificate https://raw.github.com/pulecp/virtualmaster-turnkey-import/master/install.sh

5) Now open terminal on your computer and run this (it may take a few minutes), where x.x.x.x is IP address your server:
	
    ssh root@x.x.x.x 'sh -s' < install.sh

6) After ending ssh connection (terminal promt returns on your computer) go on website with your server and open "Console". Here only press "Enter" and close this pop-up console window.
#### Create your new image
7) Now create your template by "Save As Image" button on website. Give it some name and create it.
#### Create new server from image
8) On top of website click on My images, choose your new image and Create New Server by button on left side.
#### Enjoy TurnKey
9) Remember root password for login over ssh. Passwords to application (e.g. WordPress), MySQL and others you find in **/root/passwords.txt**.

## Other images by customizing install script
install.sh is prepared for install WordPress. You can **deploy all Turnkey Linux** images of course.
Only download change-image.sh and run it. This script is interactive and edits install.sh. Internet connection needed!:

	wget --no-check-certificate https://raw.github.com/pulecp/virtualmaster-turnkey-import/master/change-image.sh
	./change-image.sh

Now you can continue in installation with step number 5.

## Why too much work
It's not possible to install anything in virtualization environment like on a classic architecture. We must adjust
the system to virtualization layer. Turnkey Linux helps us in this way providing "tarball" of the system prepared for
Xen hypervisor.

Nevertheless this is only begin of whole automatization of installation process. We must then edit this "tarball". From
renaming devices, over changing network configuration to generating new passwords. All changes are visible in install script.

## Entrails

If you take a look at the scripts which is launched on your remote server via ssh, you can see downloading your image and
.deb package firstboot from our GitHub https://github.com/Virtualmaster. This package hooks first boot and prepares the system to get right network settings.
Next important part is generating secure passwords for databases and applications. This passwords togehter with other
credentials is saved in root home directory. Thanks this feature you can start and immediatelly use your new server with
TurnKey Linux. TurnKey sets this password at first boot thanks to "inithooks"
http://www.turnkeylinux.org/docs/inithooks. Inithooks should be universal for all TurnKey images.

In the scripts are duplicated two mirrors to avoiding unavailability. List of mirrors is here: http://www.turnkeylinux.org/mirrors

## Requirements
* Minimal RAM size: 256MB
* Minimal HDD size: 1536MB (depends on size of image)

