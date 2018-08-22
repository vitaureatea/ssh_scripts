#/bin/bash

stack_dir=/tmp/fc-jstack
# change "fctomcat00" to the keyword which match to your tomcat
java_pid=`ps aux |grep java |grep fctomcat00|awk '{print $2}'`

# stack dump
/usr/java/jdk1.7.0_79/bin/jstack ${java_pid} > ${stack_dir}/`date +'%Y%m%d-%H%M%S'`.jstack

# delete oldversion
filenum=`/bin/ls ${stack_dir}/*.jstack|wc -l`
if [ $filenum -gt 120 ];
then
    /bin/ls -rt ${stack_dir}/*.jstack|head -n `expr $filenum - 120`|xargs -i rm -rf {};
fi