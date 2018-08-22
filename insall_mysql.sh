#!/bin/bash
# desc: mysql安装脚本

#创建mysql用户
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

#下载MySQL二进制文件安装
cd /usr/local/src
wget https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.36-linux-glibc2.5-x86_64.tar.gz
tar zxvf mysql-5.6.36-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
cd /usr/local
ln -s mysql-5.6.36-linux-glibc2.5-x86_64  mysql
mkdir  -pv /data/mysql
chown -R mysql:mysql  mysql  mysql-5.6.36-linux-glibc2.5-x86_64  /data/mysql

#初始化mysql
cd mysql
scripts/mysql_install_db --user=mysql    --datadir=/data/mysql
rm -rf my.cnf /etc/my.cnf
cp support-files/mysql.server /etc/init.d/mysqld
chkconfig  mysqld on

#启动mysql
service mysqld start
