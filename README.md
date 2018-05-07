这是一个在虚拟机（相对）快速安装Archlinux的脚本，
====
一，在使用这个脚本之前，请先做好以下准备
====

1.从archlinux 官网下载镜像
<br/>
<br/>
2.在vmware创建新的虚拟机，选择iso时，选择你下载的镜像，vmware无法识别你的镜像的发行版，是正常的，因此下一步的version手动选择other Linux 4.x or later kernel 64-bit，后面的硬盘可以选择Create a new virtual disk，大小我一般给20G
3.确保联网，ping 114.114.114.114
<br/>
<br/>
4.把脚本放进你的虚拟机<br/>
a,开启虚拟机后，把脚本放进你的安装系统是个麻烦事，因为我没有服务器，，，所以我用另一个虚拟机搭了个本地服务器，然后同过scp -r user@ip:<path to your file>的方法放进去，当然，如果你有服务器就更好了，把脚本放进你的服务器去，wget下载这两个脚本，然后chmod +x beforechroot.sh  chmod +x chrmod +x chroot.sh,再<br/>
  <code>#./beforechroot.sh</code>
<br/>
5,<b>一定要选对你的设备！！！</b>，因为这个脚本将会默认格式化/dev/sda，所以当脚本进行到choose your device的时候，根据脚本输出的内容，看你的设备空间大小来选择，20秒内，你可以输入你的设备，然后回车来改变默认值，
输入格式：<br/>
  <code>/dev/sda</code>
或者<br/>
  <code>/dev/sdb</code>
或者<br/>
  <code>/dev/sdc</code>
具体的根据屏幕输出的内容（你设备的容量）选择<br/>




二，用法（两个脚本必须放在同一个目录下，包括（chroot.sh    beforechroot.sh）<br/>
=====
<br/>
<br/>
<code>#./beforechroot.sh</code>
<br/>
<br/>
后面的根据屏幕提示，进行输入（当然你可以什么也不做，这样默认设备就是/dev/sda，但是这一步最好要确认确认一下，以后的步骤提示输入统统都可以放着不管）
<br/>
/dev/sd?
<br/>
这个？就是你要确定的设备
<br/>

<br/>
三，补充
======
<br/>
1.脚本会检测你是否设置了UEFI启动，如果你是以BIOS方式打开的，你可以关机后在虚拟机里面设置为UEFI启动，当然BIOS安装其实也没什么问题。
<br/>
<br/>
2.如果仅仅执行./beforechroot.sh，然后不动它了，将会默认配置
<br/>
镜像源:tsingshua.edu
root密码000000,<br/>
新建用户mike,密码000000<br/>
hostname：mikehost<br/>
图形界面管理器:sddm<br/>
桌面环境:xfce4<br/>
引导：grub<br/>
分区：<br/>
BIOS:MBR<br/>
/mnt        13G<br/>
UEFI<br/>
/mnt        12G<br/>
/boot       512M<br/>
默认应用：vim,zsh,tmux,git,screenfetch,google-chrome,yaourt,fakeroot<br/>
配置：Vundle，oh-my-zsh,tmux<br/>
一些字体：powerfont,ttf-dejavu,wqy-microhei,wqy-zenhei<br/>
<br/>
<br/>
3.此脚本仅供测试，别把有重要数据的u盘或者硬盘来测试，不然。。。，欢迎加入Arch邪教（滑稽）
<br/>
