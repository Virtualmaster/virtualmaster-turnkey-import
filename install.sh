#!/bin/sh

genpasswd() {
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c 10 | xargs
	}

#generate password and save image name
DB_PASS=`genpasswd`
APP_PASS=`genpasswd`
TK_IMAGE='turnkey-appengine-java-12.0-squeeze-x86-xen.tar.bz2'

#create new filesystem, mount it
mkdir -p /mnt/root
mkfs.ext3 -L root /dev/xvda
mount /dev/xvda /mnt/root

#wget turnkey tarball and vm-firtsboot; two mirror for failed download
wget -q -P /mnt/root http://mirror2.hs-esslingen.de/turnkeylinux.org/xen/$TK_IMAGE || rm -f /mnt/root/$TK_IMAGE
if [ ! -f "$TK_IMAGE" ]; then
	wget -q -P /mnt/root http://ftp.halifax.rwth-aachen.de/turnkeylinux/xen/$TK_IMAGE || echo "It's not able download image...exiting"
	exit 1
fi
	
tar jxf /mnt/root/$TK_IMAGE -C /mnt/root/
rm -f /mnt/root/$TK_IMAGE
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
export APP_DOMAIN=domain.com
export APP_PASS=$APP_PASS
export SEC_UPDATES=FORCE
export ETCKEEPER_COMMIT=SKIP
EOF

#write passwords into /root/passwords.txt
cat>/root/passwords.txt<<EOF
Here is general settings and login information used for all images.
For example your image needn't have database. Password is generated but nowhere used.

Default e-mail (used only in selected images): test@domain.com
Default domain (used only in selected images): domain.com

Password into database: $DB_PASS
Username into application: admin
Password into application: $APP_PASS

For example webmin managment is accessable by username: root and your root password.
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

rm -f /mnt/root/root/.bash_history
poweroff
