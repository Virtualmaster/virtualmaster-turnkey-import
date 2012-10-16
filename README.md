virtualmaster-turnkey-import -- IN HOT PROGRESS!!!!
============================

How-to and script for import TurnKey Linux into www.virtualmaster.com


## Install
Make only a few steps to start fully prepared TurnKey image, ready-to-use solution www.turnkeylinux.org.


* Create virtual server with whatever image and turn on it.
* After complete boot shutdown and start "Boot rescue".
* Remember root password and IP address your new server showed in pop-up console and close it.
* Download install script
	wget --no-check-certificate https://raw.github.com/pulecp/virtualmaster-turnkey-import/master/wordpress-install.sh
* Now open terminal on your computer and run. x.x.x.x is IP address your server:
	ssh root@x.x.x.x 'sh -s' < wordpress-install.sh
* After ending ssh connection go on website with your server and open "Console". Here only press "Enter" and close this pop-up console window.
* Now create your template by "Save As Image" button on website. Give it some name and create it.
* On top of website click on My images, choose your new image and Create New Server by button on left side.


## Requirements
* Minimal requirements: 256MB RAM!!!






