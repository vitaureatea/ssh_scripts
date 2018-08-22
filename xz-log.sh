#!/bin/bash
which xz

if [  $? -ne 0 ];then
yum install -y xz

else
   echo "开始压缩日志"
fi


logs_name=(localhost_access_log.20*  localhost.20*  elf_office.log.20* catalina.2018*  catalina.out-201* e68_middleService_error.log.20*  qy8_middleService_error.log.20*)

for i in ${logs_name[@]};do

find /home  -type f  -name "$i" -mtime  +30  |xargs -ti rm  -rf {}
find /home  -type f  -name "$i" |xargs -ti xz {}

done



find /home  -type f  -name "catalina.out-20*" -mtime  +30  |xargs -ti rm  -rf {}
find /home  -type d  -name "D:" |xargs -ti rm  -rf {}