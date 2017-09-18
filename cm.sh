#!/bin/bash

PWD=`pwd`
Yumdir="/etc/yum.repos.d"
#remove openjdk
jdk=`rpm -qa | grep openjdk`
yum -y remove $jdk >/dev/null
#stop selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
#stop iptables
systemctl stop firewalld
systemctl disable firewalld
iptables -F
#创建data
mkdir /data
#关闭虚拟网卡
virsh net-list
virsh net-destroy default

virsh net-undefine default
systemctl stop libvirtd
systemctl disable libvirtd


#操作系统内核设置
echo never >  /sys/kernel/mm/redhat_transparent_hugepage/defrag
echo 'echo never >  /sys/kernel/mm/redhat_transparent_hugepage/defrag' >> /etc/rc.local
sysctl -w vm.swappiness=10 #临时设置
echo 'vm.swappiness=10' >> /etc/sysctl.conf 
sysctl -p #激活设置。
