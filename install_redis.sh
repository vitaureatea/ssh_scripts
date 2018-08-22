#!/bin/bash
# desc: redis安装脚本
### 需要gcc gcc-c++  配置文件 启动脚本查看最下面###

#下载最新redis版本
cd /usr/local/src/
wget http://download.redis.io/releases/redis-3.2.6.tar.gz
tar zxvf redis-3.2.6.tar.gz

cd redis-3.2.6
make
make install
mkdir /etc/redis
mkdir /var/log/redis -p
mkdir /opt/redis -p

## 拷贝默认配置文件，并根据指定端口进行修改
## 以端口6389举例
#注意端口号（这里不使用默认端口）
cp redis.conf /etc/redis/6389.conf
#修改为守护进程
sed -i 's/daemonize no/daemonize yes/g' /etc/redis/6389.conf
#修改默认端口
sed -i 's/port 6379/port 6389/g' /etc/redis/6389.conf
#指定log路径
sed -i 's#logfile ""#logfile "/var/log/redis/redis_6389.log"#g' /etc/redis/6389.conf
#修改本地数据库名称，可能要开多个redis
sed -i 's/dbfilename dump.rdb/dbfilename dump_6389.rdb/g' /etc/redis/6389.conf
#修改本地数据库存放路径
sed -i 's#dir ./#dir /opt/redis#g' /etc/redis/6389.conf
#添加redis密码
sed -i 's/# requirepass foobared/requirepass gsmcredis/g' /etc/redis/6389.conf
#开启持久化
sed -i 's/appendonly no/appendonly yes/g' /etc/redis/6389.conf
#修改日志名称
sed -i 's/appendfilename "appendonly.aof"/appendfilename "appendonly_6389.aof"/g' /etc/redis/6389.conf
#修改pid文件名称
sed -i 's#pidfile /var/run/redis_6379.pid#pidfile /var/run/redis_6389.pid#g' /etc/redis/6389.conf

## 配置守护脚本，命名规则为"redis端口号"，例如"redis6389"
echo '#!/bin/sh
#chkconfig: 2345 58 68
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

REDISPORT=6389
EXEC=/usr/local/bin/redis-server
CLIEXEC=/usr/local/bin/redis-cli

PIDFILE=/var/run/redis_${REDISPORT}.pid
CONF="/etc/redis/${REDISPORT}.conf"
AUTH_PASSWORD="gsmcredis"

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT -a $AUTH_PASSWORD shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac' > /etc/init.d/redis6389
