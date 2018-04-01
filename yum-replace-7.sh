#!/bin/sh
 
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
 
#cd rhel7
#cp CentOS-Base.repo /etc/yum.repos.d/
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -P /etc/yum.repos.d/
sed -i "s//$releasever/7/g" /etc/yum.repos.d/CentOS7-Base-163.repo
 
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm
rpm -ivh python-iniparse-0.4-9.el7.noarch.rpm --force --nodeps
 
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
rpm -ivh yum-metadata-parser-1.1.4-10.el7.x86_64.rpm --force --nodeps
 
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-3.4.3-154.el7.centos.noarch.rpm

wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-42.el7.noarch.rpm                                   
                                             
rpm -ivh yum-3.4.3-154.el7.centos.noarch.rpm yum-plugin-fastestmirror-1.1.31-42.el7.noarch.rpm --force --nodeps
         
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