virtualmaster-turnkey-import -- IN HOT PROGRESS!!!!
============================

The how-to and the script for import TurnKey Linux into www.virtualmaster.com

Make only a few steps to start fully prepared TurnKey image, ready-to-use solution www.turnkeylinux.org!

## Install

1) Create virtual server with whatever image and turn it on.

2) After complete boot shutdown and start "Boot rescue".

3) Remember root password and IP address your new server showed in pop-up console and close it.

4) Download install script from this repository:

    wget --no-check-certificate https://raw.github.com/pulecp/virtualmaster-turnkey-import/master/wordpress-install.sh

Now open terminal on your computer and run this, where x.x.x.x is IP address your server:
	
    ssh root@x.x.x.x 'sh -s' < wordpress-install.sh

5) After ending ssh connection go on website with your server and open "Console". Here only press "Enter" and close this pop-up console window.

6) Now create your template by "Save As Image" button on website. Give it some name and create it.

7) On top of website click on My images, choose your new image and Create New Server by button on left side.

8) Remember root password. Passwords to application (e.g. WordPress), MySQL and others you find in /root/passwords.txt

## Requirements
Minimal RAM size: 256MB









