#!/bin/bash
#Author:Zack &  Danny
#Description : The Script For Business  Team  Install  Soft
#Nginx 1.10  JDK1.7 TOMCAT7  Redis 3.2.6  Rsync

Nginx_Url='http://nginx.org/download/nginx-1.10.3.tar.gz'
Jdk17_Url='http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz'
Tomcat7_Url='http://mirror.rise.ph/apache/tomcat/tomcat-7/v7.0.76/bin/apache-tomcat-7.0.76.tar.gz'
Redis_Url='http://download.redis.io/releases/redis-3.2.8.tar.gz'
Download_Path='/opt/'
#Dowload Frist
cd   $Download_Path
wget -c $Nginx_Url
wget -c $Tomcat7_Url
wget -c $Redis_Url
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -c $Jdk17_Url

#Init Yum
Init_Yum () {
     rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
     rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
	 yum clean all
     yum  makecache
     yum -y update bash openssl glibc
	 yum -y install apr* tomcat-native  rng-tools
	 echo 'EXTRAOPTIONS="--rng-device /dev/urandom"' >/etc/sysconfig/rngd
	 service rngd start
}

#Install Nginx
Install_Nginx (){
		cd   $Download_Path
		yum -y install gcc gcc-c++ autoconf automake libtool  zlib zlib-devel openssl openssl-devel pcre-devel
		useradd -g www -s /sbin/nologin -M www
		tar -zxvf  nginx-1.10.3.tar.gz
		cd 	nginx-1.10.3/
		./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-http_realip_module --with-http_gunzip_module --with-http_gzip_static_module --with-file-aio
		make && make install
}

Install_Redis (){
		cd   $Download_Path
		tar  -zxvf  redis-3.2.8.tar.gz
		cd   redis-3.2.8
		make && make install


}
Install_JDK (){
		cd   $Download_Path
		tar  -zxvf  jdk-7u79-linux-x64.tar.gz
		mkdir /usr/java/
		mv   jdk1.7.0_79   /usr/java/
cat >> /etc/profile << EOF
JAVA_HOME=/usr/java/jdk1.7.0_79
JRE_HOME=/usr/java/jdk1.7.0_79/jre
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/jt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export JAVA_HOME JRE_HOME PATH CLASSPATH
EOF
 source  /etc/profile
}


Init_Yum
Install_Nginx
Install_Redis
Install_JDK
