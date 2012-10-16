virtualmaster-turnkey-import
============================

How-to and script for import TurnKey Linux into www.virtualmaster.com


Make only a few steps to start fully prepared TurnKey image, ready-to-use solution www.turnkeylinux.org.


* Create virtual server with whatever image and turn on it.

* After complete boot shutdown and start "Boot rescue".

* Remember root password and IP address showed in pop-up console and close it.

* Clone this repository or download install script

	https://raw.github.com/pulecp/virtualmaster-turnkey-import/master/wordpress-install.sh

* Now open terminal on your computer and run:

	ssh root@x.x.x.x 'sh -s' < wordpress_install.sh



