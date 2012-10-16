#!/bin/sh

genpasswd() {
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c 10 | xargs
	}

#generate password
DB_PASS=`genpasswd`
APP_PASS=`genpasswd`

#create new filesystem, mount it
mkdir -p /mnt/root
mkfs.ext3 -L root /dev/xvda
mount /dev/xvda /mnt/root

#wget turnkey tarball and vm-firtsboot
######################################################################################################
### BELOW IS POSSIBLE CHANGE LINK TO XEN TARBALL
### HERE IS LIST OF IMAGES: http://mirror2.hs-esslingen.de/turnkeylinux.org/xen/
### IT IS SUFFICIENT TO COPY NAME AND PASTE IT AFTER LAST '/' IN LINK INSTEAD tunrkey-wordpress-12.0...
### IF YOU CHANGE IMAGE PLEASE EDIT ALL 3 LINE BELOW SIMILAR
######################################################################################################
wget -q -P /mnt/root http://mirror2.hs-esslingen.de/turnkeylinux.org/xen/turnkey-wordpress-12.0-squeeze-x86-xen.tar.bz2 > /dev/null
tar jxf /mnt/root/turnkey-wordpress-12.0-squeeze-x86-xen.tar.bz2 -C /mnt/root/
rm -f /mnt/root/turnkey-wordpress-12.0-squeeze-x86-xen.tar.bz2
wget -q -P /mnt/root/root --no-check-certificate https://github.com/Virtualmaster/virtualmaster-firstboot/raw/master/virtualmaster-firstboot_0.2-1_all.deb > /dev/null

#create script run under chroot
cat>/mnt/root/root/script_chroot.sh<<END_SCRIPT
#!/bin/sh
#edit fstab
cat >/etc/fstab <<EOF
/dev/xvda  /     ext3  relatime  1  1
/dev/xvdb  none  swap  sw        0  0
EOF

#set locale
sed 's/# en_US.UTF-8/en_US.UTF-8/' -i /etc/locale.gen
locale-gen

#install vm-firstboot
dpkg -i /root/virtualmaster-firstboot_0.2-1_all.deb
rm -f /root/virtualmaster-firstboot_0.2-1_all.deb

#remove resolvconf
apt-get -y remove resolvconf

#edit /boot/grub/menu.lst
sed 's#\<root=#init=/sbin/init.vmin root=#' -i /boot/grub/menu.lst
sed 's#root=/dev/xvda1#root=/dev/xvda#' -i /boot/grub/menu.lst

#right terminal
echo "T0:2345:respawn:/sbin/getty -L hvc0 38400 linux" >>/etc/inittab
sed 's/.* tty[2-6]$/#\0/' -i /etc/inittab

#edit inithooks with generated passwords 
cat>/etc/inithooks.conf<<EOF
export HUB_APIKEY=SKIP
export DB_PASS=$DB_PASS
export APP_EMAIL=test@domain.com
export APP_PASS=$APP_PASS
export SEC_UPDATES=FORCE
export ETCKEEPER_COMMIT=SKIP
EOF

#write passwords into /root/passwords.txt
cat>/root/passwords.txt<<EOF
Password into MySQL database: $DB_PASS
Default e-mail: test@domain.com

Username into application: admin
Password into application: $APP_PASS
EOF

#remove turnkey script editing root password
rm -f /usr/lib/inithooks/firstboot.d/30rootpass
END_SCRIPT

chmod u+x /mnt/root/root/script_chroot.sh

#mount all needed and chroot
mount -t proc proc /mnt/root/proc
mount -t sysfs sysfs /mnt/root/sys
mount --bind /dev /mnt/root/dev
mount -t tmpfs tmpfs /mnt/root/dev/shm
mount -t devpts devpts /mnt/root/dev/pts


#run script in chroot and delete it
chroot /mnt/root /root/script_chroot.sh
rm -f /mnt/root/root/script_chroot.sh

exit
rm -f /mnt/root/root/.bash_history
poweroff
