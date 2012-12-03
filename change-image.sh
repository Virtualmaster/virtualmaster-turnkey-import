#!/bin/bash

options=`wget -q -O - http://ftp.halifax.rwth-aachen.de/turnkeylinux/xen/ | sed -n '/\.tar\.bz2">/ s/.*href="\(turnkey.*bz2\)".*/\1/p' | tr '\n' ' '`

if [ "`echo $options | grep "turnkey"`" = "" ]; then
	options=`wget -q -O - http://mirror2.hs-esslingen.de/turnkeylinux.org/xen/ | sed -n '/\.tar\.bz2">/ s/.*href="\(turnkey.*bz2\)".*/\1/p'`
fi

if [ "`echo $options | grep "turnkey"`" = "" ]; then
		echo -e "\033[33;31mIt's not able download list of images."
		echo "Exit"
		exit 3
fi

file='install.sh'

PS3='
Insert your choice: '

#list images and read a choice
#echo options $options
select opt in $options; do

#right input test
if [ "$opt" = "" ]; then
	echo "YOUR CHOICE IS INVALID"
	echo "Please insert right number"
else
	echo "Your choice is: $opt"
	if [ -f $file ]; then
		sed -i "/^TK_IMAGE/ s/^TK_IMAGE.*/TK_IMAGE='$opt'/" $file &&
		echo -e "\033[33;32mFile $file was successfuly edited." || echo -e "\033[33;31mFile was not able edit."
		exit 0
	else
		echo -e "\033[33;31mFile $file doesn't exist in current directory"
		exit 2
	fi
fi
done
