#!/bin/bash

echo "chroot setting time----"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc  --utc
pacman -S  vim dialog wpa_supplicant ntfs-3g networkmanager << EFOINIT
y
EFOINIT
echo "done"


echo "setting locale=========="
if test -e /etc/local.gen_bak
then
	echo "local.gen_bak is exited"
else
	cp /etc/locale.gen /etc/locale.gen_bak
fi
echo 'zh_CN.UTF-8 UTF-8' > /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo "done"


echo "===========setting hostname (defalut:mikehost)====="
read -p "Enter your hostname:" -t 5 YOUR_HOSTNAME
MY_INPUTE_STATE=$?
echo $MY_INPUTE_STATE
if [ $MY_INPUTE_STATE -eq 0 ]
then
    echo "your hostname is $YOUR_HOSTNAME"
elif [ $MY_INPUTE_STATE -eq 142 ]
then
    YOUR_HOSTNAME="mikehost"
    echo "default hostname is :$YOUR_HOSTNAME"
fi
echo $YOUR_HOSTNAME > /etc/hostname

echo "127.0.0.1	localhost.localdomain	localhost
::1		localhost.localdomain	localhost
127.0.1.1	${YOUR_HOSTNAME}.localdomain	${YOUR_HOSTNAME}" > /etc/hosts
unset MY_INPUTE_STATE
echo "done"
echo "==========setting passwd===========(default is 000000)"

read -p "Enter you root passwd (in 5 second) :" -t 5 MY_ROOT_PASSWD
MY_INPUT_STATE=$?
if [ $MY_INPUT_STATE -eq 142 ]
then
	passwd << EOF1
	000000
	000000
EOF1
elif [ $MY_INPUT_STATE -eq 0 ]
then
	passwd << EOF2
	$MY_ROOT_PASSWD
	$MY_ROOT_PASSWD
EOF2
fi

echo "adduser -m mike, passwd is 000000"
useradd -m mike
passwd mike << EOFMIKE
000000
000000
EOFMIKE

#backup sudoers
if test -e /etc/sudoers_bak
then
	echo "sudoers is already backup "
else
	cp /etc/sudoers /etc/sudoers_bak

if ( grep 'mike' /etc/sudoers )
then
	echo 'mike ALL=(ALL) ALL' >> /etc/sudoers
else
	echo 'mike is exist'
fi
echo "done"

echo "============installing grub=================default for UEFI"
pacman -S grub-efi-x86_64 os-prober efibootmgr << EOF2
y
EOF2
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

unset MY_INPUT_STATE
echo "1.nothing"
echo "2.yes,I want to adjust"
read -p "anything wrong ?" -t 5 ANY_WRONG
MY_INPUT_STATE=$?
if [ $MY_INPUT_STATE -eq 142 ]
then
	ANY_WRONG=1
elif [ $MY_INPUT_STATE -eq  0 ]
then
	if [ $ANY_WRONG -eq 1 ]
	then
		echo "now install gnu"
	else
		echo "adjust it!"
		exit
	fi
else
	echo "unknow the state: $MY_INPUT_STATE "
fi

echo "Installing xfce4 xorg sddm====================="
pacman -Sy xorg xfce4 sddm xf86-video-vesa network-manager-applet  sudo << EOF3
y
EOF3
MY_INSTALL_STATE=$?
if [ $MY_INSTALL_STATE -eq 1 ]
then
pacman -Sy xorg xfce4 sddm xf86-video-nouveau network-manager-applet  sudo << EOF3
y
EOF3
else
	echo "done"
fi


echo "systemctl================================>>"
systemctl enable sddm
systemctl disable netctl
systemctl enable NetworkManager
pacman -S EOF5
y
EOF5
echo "done"

echo "setting yaourt=============================>>"
if ( grep 'archlinuxcn' /etc/pacman.conf)
then
	archlinuxcn is exist
else
	echo -e '
	[archlinuxcn]
	SigLevel=Never
	Server = http://repo.archlinuxcn.org/$arch
	' >> /etc/pacman.conf
fi
pacman -Sy yaourt fakeroot << EOFYAOURT
y
EOFYAOURT

echo "done"
