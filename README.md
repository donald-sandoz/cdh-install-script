# cdh-install-script
这是一个配置cdh基本环境的脚本，只支持centos7系统。
声明:
	在使用前，请查看主节点系统时间和实际时间是否一致，如果不一致，请手动修改。
	如果公司内部有时间服务器，请修改file下的ntp.conf.master的配置文件，指向时间服务器。
1、在master节点创建id_rsa.pub
ssh-keygen -t rsa
2、修改hosts文件
1.1.1.1 hadoop1.fdad.test hadoop1
1.1.1.2 hadoop2.fdad.test hadoop2
3、修改主节点的主机名
hostnamectl set-hostname hadoop1.fdad.test
for i in `cat /etc/hosts | grep -v 'localhost' | awk '{print $1}'`;do ssh-keyscan $i >> /root/.ssh/known_hosts;done
4、执行脚本cm.sh
5、执行master.sh
6、执行changehostname.sh
7、kerberos的配置文件按照自己的需求进行修改
/root/cm/file/ kdc.conf
/root/cm/file/ krb5.conf
/root/cm/file/ kadm5.acl
