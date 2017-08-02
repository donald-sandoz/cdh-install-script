#!/bin/bash
NodeName=`cat /etc/hosts | grep -v "localhost" | awk '/./ {print $2}' | head -n1`		#指定主节点的主机名

#install ntpd

	yum install ntpd -y >/dev/null 2>>err.log
	cp /root/ntp.conf.node /etc/ntp.conf
	sed -i "22c server $NodeName iburst" /etc/ntp.conf
	systemctl start ntpd
	systemctl enable ntpd
#install kdc
	yum install krb5-workstation krb5-libs
	echo "y" | cp -b /root/krb5.conf /etc/krb5.conf
#jdk install
	yum -y install oracle-j2sdk1.7 >/dev/null 2>>err.log
	echo "export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera" >> /etc/profile
	echo "export JRE_HOME=/usr/java/jdk1.7.0_67-cloudera/jre" >> /etc/profile
	echo "jdk install success"
#cloudera-agent install
	yum install cloudera-manager-agent -y >/dev/null 2>>err.log
	sed -i "3c server_host=$NodeName" /etc/cloudera-scm-agent/config.ini
	/etc/init.d/cloudera-scm-agent start
	echo "cloudera-manager-agent success"
