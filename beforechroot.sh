#!/bin/bash
#time=========================================
echo "step1.==========setting time..."
timedatectl set-ntp true
timedatectl set-timezone Asia/Shanghai
timedatectl set-ntp true
hwclock --systohc --utc

#block=======================================no home block=
echo "step2.==========block-formatting"
lsblk
echo -e "choose your block (default is /dev/sda) \n\n NOTICE:it will clear all you content from you U!\n\n"
read -p "Enter you block:" -t 10 BLOCK

echo "your block is $BLOCK"
echo "====gdisk===="
sudo gdisk $BLOCK << EOF
o
y

n
1

+512M
ef00
n
2

+12G
8300
w
y

EOF

echo "mkfs...===================="
mkfs.vfat -F32 ${BLOCK}1 << EOF
y
EOF
mkfs.ext4 ${BLOCK}2 << EOF
y
EOF
echo "mkdir--mount==============="
mount ${BLOCK}2 /mnt
mkdir -p /mnt /mnt/boot
mount ${BLOCK}1 /mnt/boot
lsblk
echo "change rope================(default:tuna)"
if test -e /etc/pacman.d/mirrorlist_bak
then
	echo 'mirrorlist_bak is exist'
else
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist_bak
fi
echo 'Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

echo "installing base base-devel==============="
pacstrap /mnt base base-devel

echo "genfstab -L /mnt /mnt/etc/fstab"
genfstab -L /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

echo "Copying chroot.sh to new root=================>>"
cp /root/chroot.sh /mnt/
arch-chroot /mnt  /mnt/chroot.sh
echo "finish,thank you, now you can run the chroot.sh in new root"

