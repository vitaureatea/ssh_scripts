#!/bin/bash
# author: itimor
# desc: jdk安装脚本

download_url='http://69.172.86.99:998'
jdk_env='/etc/profile.d/java-env.sh'
rpm_url='/usr/local/src'

# 熵池底包
yum -y install rng-tools
echo 'EXTRAOPTIONS="--rng-device /dev/urandom"' >/etc/sysconfig/rngd
service rngd start
chkconfig rngd on

# apr模式(已经改变为rpm安装的方式)
#yum install -y epel-release apr*
#yum install -y tomcat-native


function jdk6() {
  jdk_tar='jdk-6u45-linux-x64.bin'
  jdk_dir='jdk1.6.0_45'
  
  [ -d /usr/java ] || mkdir /usr/java
  [ -f ${jdk_tar} ] || wget $download_url/${jdk_tar}
  chmod  +x $jdk_tar
  [ -d ${jdk_dir} ] || ./$jdk_tar
  [ -d /usr/java/${jdk_dir} ] || mv $jdk_dir /usr/java
  
  echo 'export JAVA_HOME=/usr/java/jdk1.6.0_45
  export JRE_HOME=${JAVA_HOME}/jre
  export PATH=$PATH:${JAVA_HOME}/bin:${JRE_HOME}/bin
  export CLASSPATH=${JAVA_HOME}/lib:${JRE_HOME}/lib' >$jdk_env
}

function jdk7() {
  jdk_tar='jdk-7u79-linux-x64.tar.gz'
  jdk_dir='jdk1.7.0_79'
  
  [ -d /usr/java ] || mkdir /usr/java
  [ -f ${jdk_tar} ] || wget $download_url/${jdk_tar}
  [ -d /usr/java/$jdk_dir ] || tar -xvf ${jdk_tar} -C /usr/java
  
  echo 'export JAVA_HOME=/usr/java/jdk1.7.0_79
  export JRE_HOME=${JAVA_HOME}/jre
  export PATH=$PATH:${JAVA_HOME}/bin:${JRE_HOME}/bin
  export CLASSPATH=${JAVA_HOME}/lib:${JRE_HOME}/lib' >$jdk_env
}

function jdk8() {
  jdk_tar='jdk-8u144-linux-x64.tar.gz'
  jdk_dir='jdk1.8.0_144'
  
  [ -d /usr/java ] || mkdir /usr/java
  [ -f ${jdk_tar} ] || wget $download_url/${jdk_tar}
  [ -d /usr/java/$jdk_dir ] || tar -xvf ${jdk_tar} -C /usr/java
  
  echo 'export JAVA_HOME=/usr/java/jdk1.8.0_144
  export JRE_HOME=${JAVA_HOME}/jre
  export PATH=$PATH:${JAVA_HOME}/bin:${JRE_HOME}/bin
  export CLASSPATH=${JAVA_HOME}/lib:${JRE_HOME}/lib' >$jdk_env
}

function installationRPM() {
  centOs6=`cat /etc/centos-release | grep "release 6" | wc -l `
  # rmp_tag=1，这个变量没有用，为什么还保留在脚本里面？
  if [ "$centOs6" = 1 ];then
  	echo "Linux operating system is centOS 6"
  	apr=apr-1.3.9-5.el6_9.1.x86_64.rpm
  	apr_util=apr-util-1.3.9-3.el6_0.1.x86_64.rpm
  	tomcat_native=tomcat-native-1.1.34-1.el6.x86_64.rpm
  elif [ "$centOs6" = 0 ];then
  	echo "Linux operating system is centOS 7"
  	apr=apr-1.4.8-3.el7_4.1.x86_64.rpm
  	apr_util=apr-util-1.5.2-6.el7.x86_64.rpm
  	tomcat_native=tomcat-native-1.2.17-1.el7.x86_64.rpm
  fi
  apr_url="$rpm_url/$apr"
  apr_util_url="$rpm_url/$apr_util"
  apr_tomcat_native_url="$rpm_url/$tomcat_native"
  
  [ -e ${apr} ] || wget $download_url/${apr}
  [ -e ${apr_util} ] || wget $download_url/${apr_util}
  [ -e ${tomcat_native} ] || wget $download_url/${tomcat_native}
  
  current_path=`pwd`
  if [ $current_path != $rpm_url ]; then
    mv $apr $rpm_url
    mv $apr_util $rpm_url
    mv $tomcat_native $rpm_url
  fi
  
  # install apr
  rpm -ivh $rpm_url/$apr
  rpm -ivh $rpm_url/$apr_util
  rpm -ivh $rpm_url/$tomcat_native
}


case $1 in
6)
  jdk6
  installationRPM
;;
7)
  jdk7
  installationRPM
;;
8)
  jdk8
  installationRPM
;;
*)
echo "you must select jdk version!!"
echo "bash $0 6|7|8"
exit
;;
esac
