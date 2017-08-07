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
rm -f $Yumdir/*
cp /root/yum.repo $Yumdir/
cp /root/cm.repo $Yumdir/
