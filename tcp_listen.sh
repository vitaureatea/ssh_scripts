#!/usr/bin/sh

#定义过滤关键字(根据需求可调整)
Gkey=webservice


#日志路径及时间定义
Log=/home/data/tcp_listen
ILogs=/home/data/tcp_listen/info.log
ELogs=/home/data/tcp_listen/restart.log
Time=`date +"%F %H:%M:%S"`
Stime=`date +"%s"`

#如果文件夹不存在，创建文件夹
if [ ! -d "$Log" ]; then
  mkdir -p "$Log" && touch "$ILogs" "$ELogs"
fi

#定义函数及if判断流程
function re_svr(){
   if [[ "$ESresult" -gt 1000 ]]; then
        echo $Tpid |xargs kill -9 && echo -e "\033[31mESTABLISHED为$ESresult 大于1000,关闭$Tser服务成功1!执行时间: $Time\033[0m" >> $ELogs
        sleep 2
        sh $Tpath/startup.sh
		if [ $? -eq 0 ];then
           	echo "重启$Tser服务成功2! 执行时间:$Time" >> $ELogs
		else
		    echo -e "\033[31m重启$Tser服务失败2! 执行时间:$Time\033[0m" >> $ELogs
		fi
        sleep 5
   elif [[ "$CWresult" -gt 270 ]]; then
        echo $Tpid |xargs kill -9 && echo -e  "\033[31mCLOSE_WAIT为$CWresult 大于270,关闭$Tser服务成功1! 执行时间:$Time\033[0m" >> $ELogs
        sleep 2
        sh $Tpath/startup.sh
		if [ $? -eq 0 ];then
           	echo "重启$Tser服务成功2! 执行时间:$Time" >> $ELogs
		else
		    echo -e "\033[31m重启$Tser服务失败2! 执行时间:$Time\033[0m" >> $ELogs
		fi
        sleep 5
   elif [[ $[$Stime-$LTstat] -gt 600 ]]; then
        echo $Tpid |xargs kill -9 && echo -e "\033[31mcatalina日志状态变动时间 $(($Stime-$LTstat))大于600S,关闭$Tser服务成功1! 执行时间:$Time\033[0m" >> $ELogs
        sleep 2
        sh $Tpath/startup.sh 
		if [ $? -eq 0 ];then
           	echo "重启$Tser服务成功2! 执行时间:$Time" >> $ELogs
		else
		    echo -e "\033[31m重启$Tser服务失败2! 执行时间:$Time\033[0m" >> $ELogs
		fi
        sleep 5
   else
         echo "+++++++++++++++++++++++++++$Tser不需要重启服务! 执行时间:$Time">>$ILogs
   fi
}

#获取Tomcat服务及pid进程号
p_s=`ps -ef|grep $Gkey|grep -v grep |awk '{print $2, $9}'|awk -F [" "=]+ '{print $1, $3}'|awk -F [" "/]+ '{print $4"="$1}'`


#for语句循环获取各Tomcat服务TCP状态连接数
for i in $p_s
do
    Tpid=`echo $i|awk -F [=] '{print $2}'`
    Tser=`echo $i|awk -F [=] '{print $1}'`
    ESresult=`netstat -tanp |grep $Tpid |awk '/^tcp/ {++S[$(NF-1)]} END {for(a in S) print a, S[a]}'|grep ESTABLISHED|awk '{print $2}'`
    CWresult=`netstat -tanp |grep $Tpid |awk '/^tcp/ {++S[$(NF-1)]} END {for(a in S) print a, S[a]}'|grep CLOSE_WAIT |awk '{print $2}'`
    if [ ! -n "$ESresult" ] && [ ! -n "$CWresult" ];then
       continue
    else
        LTstat=`stat -c %Y "/home/$Gkey/$Tser/logs/catalina.out"`
        Tpath=/home/$Gkey/$Tser/bin
        re_svr
    fi
done

