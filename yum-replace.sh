#!/bin/sh
#author : JackDwan
#for Red Hat Enterprise Linux 5/6/7
 
. /etc/init.d/functions
bit=`getconf LONG_BIT`
release=`sed -r -n 's/(.*) ([[:digit:]])/.([[:digit:]]) (.*)//2/p' /etc/redhat-release`
 
if [ $UID -ne 0  ]
then
  echo "Please use 'root' to execute this script"
  exit 1
fi
 
[ `rpm -qa |grep yum|wc -l` -ge 1  ] && { 
rpm -qa |grep yum | xargs rpm -e --nodeps
} 
 
[ -e /tmp/yumupdate ] || mkdir /tmp/yumupdate
cd /tmp/yumupdate
 
rhel5() 
{
wget http://mirrors.163.com/.help/CentOS5-Base-163.repo -P /etc/yum.repos.d/
sed -i "s//$releasever/5/g" /etc/yum.repos.d/CentOS5-Base-163.repo
 
case $bit in
  32)
    wget http://mirrors.163.com/centos/5/os/i386/CentOS/yum-metadata-parser-1.1.2-4.el5.i386.rpm
    rpm -ivh yum-metadata-parser-1.1.2-4.el5.i386.rpm --nodeps
    ;;
  64)
    wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/yum-metadata-parser-1.1.2-4.el5.x86_64.rpm
    rpm -ivh yum-metadata-parser-1.1.2-4.el5.x86_64.rpm --nodeps
    ;;
esac
 
wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/yum-3.2.22-40.el5.centos.noarch.rpm
wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm
wget http://mirrors.163.com/centos/5/os/x86_64/CentOS/yum-updatesd-0.9-6.el5_10.noarch.rpm
 
rpm -ivh yum-3.2.22-40.el5.centos.noarch.rpm yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm
rpm -ivh yum-updatesd-0.9-6.el5_10.noarch.rpm
}
 
rhel6() 
{
#cd rhel6
#cp CentOS-Base.repo /etc/yum.repos.d/
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -P /etc/yum.repos.d/
sed -i "s//$releasever/6/g" /etc/yum.repos.d/CentOS6-Base-163.repo
 
wget http://mirrors.163.com/centos/6/os/x86_64/Packages/python-iniparse-0.3.1-2.1.el6.noarch.rpm
rpm -ivh python-iniparse-0.3.1-2.1.el6.noarch.rpm
 
case $bit in
  32)
    wget http://mirrors.163.com/centos/6/os/i386/Packages/yum-metadata-parser-1.1.2-16.el6.i686.rpm
    rpm -ivh yum-metadata-parser-1.1.2-16.el6.i686.rpm
    ;;
  64)
    wget http://mirrors.163.com/centos/6/os/x86_64/Packages/yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
    rpm -ivh yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
    ;;
esac
 
wget http://mirrors.163.com/centos/6/os/i386/Packages/yum-3.2.29-60.el6.centos.noarch.rpm
wget http://mirrors.163.com/centos/6/os/i386/Packages/yum-plugin-fastestmirror-1.1.30-30.el6.noarch.rpm                                          
                                             
rpm -ivh yum-3.2.29-60.el6.centos.noarch.rpm yum-plugin-fastestmirror-1.1.30-30.el6.noarch.rpm
}
rhel7(){
#cd rhel7
#cp CentOS-Base.repo /etc/yum.repos.d/
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -P /etc/yum.repos.d/
sed -i "s//$releasever/6/g" /etc/yum.repos.d/CentOS7-Base-163.repo
 
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm
rpm -ivh python-iniparse-0.4-9.el7.noarch.rpm
 
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
rpm -ivh yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
 
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-3.4.3-154.el7.centos.noarch.rpm

wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-42.el7.noarch.rpm                                   
                                             
rpm -ivh yum-3.4.3-154.el7.centos.noarch.rpm yum-plugin-fastestmirror-1.1.31-42.el7.noarch.rpm 
}
 
if [ $release -eq 6  ]
  then   
    rhel6
elif [ $release -eq 5 ]
  then
    rhel5
elif [ $release -eq 7 ]
  then
	rhel7
	
else
    echo "This Release Version is Not Supported!"
fi
        
if [ $? -eq 0  ]
  then
  action "Replace succeed." /bin/true
  else
  action "Replace failed." /bin/false
  exit 1
fi
rm -rf /tmp/yumupdate
yum clean all
yum repolist