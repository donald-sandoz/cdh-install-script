#!/bin/bash
# This is a shell script to change hostname
# version 0.1
# Created in 2017.7.31
# Creator bian

export PATH=$PATH
export USER=root
export SNAMEPRE=hadoop	#定义主机名
export PASSWD=123456   #定义密码
export PWD=`pwd`
Domain="fdad.test"		#定义域名
for i in {2..10};					#有几个node节点，写几个数字。example:{2..10} 代表主机名为2~10的节点。
 do /usr/bin/expect << EOF     ##这里用到了expect完成了确认yes和密码输入交互
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $USER@$SNAMEPRE$i.$Domain
expect {
"(yes/no)?" {send "yes\r";exp_continue}
"(yes/no)?" {send "yes\r";exp_continue}
"password:" {send "$PASSWD\r"}
}
interact
expect eof
EOF
#    ssh $USER@$SNAMEPRE$i "sed -i s/^HOST.*/HOSTNAME=$SNAMEPRE$i/ /etc/sysconfig/network";
    ssh $USER@$SNAMEPRE$i "hostnamectl set-hostname $SNAMEPRE$i.$Domain"
    scp /etc/hosts $USER@$SNAMEPRE$i.$Domain:/etc/hosts;
    scp $PWD/file/cm.repo $USER@$SNAMEPRE$i.$Domain:/root
    scp $PWD/file/yum.repo $USER@$SNAMEPRE$i.$Domain:/root
    scp $PWD/file/ntp.conf.node $USER@$SNAMEPRE$i.$Domain:/root
	  scp $PWD/file/krb5.conf $USER@$SNAMEPRE$i.$Domain:/root
    scp $PWD/cm.sh $USER@$SNAMEPRE$i.$Domain:/root
	  scp $PWD/cmnode.sh $USER@$SNAMEPRE$i.$Domain:/root
    ssh $USER@$SNAMEPRE$i "/usr/bin/bash /root/cm.sh >> cm.log"
	ssh $USER@$SNAMEPRE$i "/usr/bin/bash /root/cmnode.sh >> cm.log"
done;
