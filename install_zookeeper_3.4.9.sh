#!/bin/bash
# desc: zookeeper安装脚本
set -e

## 1. 下载zookeeper最新稳定版
ZOOBASE=/home/server
ZOOVERS=3.4.9
ZOODATA=$ZOOBASE/zookeeper-${ZOOVERS}/data

mkdir -p $ZOOBASE
cd $ZOOBASE
wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOVERS}/zookeeper-${ZOOVERS}.tar.gz
tar zxvf zookeeper-${ZOOVERS}.tar.gz

## 2. 根据部署节点修改以下配置
# 根据不同节点请注意调整配置
cd zookeeper-${ZOOVERS}

cat > conf/zoo.cfg << EOF
tickTime=2000
dataDir=/home/server/data
clientPort=2181
initLimit=5
syncLimit=2
maxClientCnxns=1000
minSessionTimeout=30000
maxSessionTimeout=60000
server.1=192.168.33.121:2888:3888
server.2=192.168.33.122:2888:3888
server.3=192.168.33.123:2888:3888
EOF

# 创建数据目录
mkdir $ZOODATA

# 创建myid文件来让zookeeper识别server身份
echo "1" > $ZOODATA/data/myid

## 3. 配置服务
sed -i '27a ZOO_LOG_DIR=${ZOOBINDIR}/../logs' ${ZOOBASE}/zookeeper-${ZOOVERS}/bin/zkEnv.sh
sed -i '28a ZOO_LOG4J_PROP="INFO,CONSOLE"' ${ZOOBASE}/zookeeper-${ZOOVERS}/bin/zkEnv.sh
mkdir ${ZOOBASE}/zookeeper-${ZOOVERS}/logs

cat > ${ZOOBASE}/zookeeper-${ZOOVERS}/conf/java.env << EOF
export JAVA_HOME=/usr/java/jdk1.8.0_144
export JVMFLAGS="-Xms512m -Xmx1024m $JVMFLAGS"
EOF

# ***** %% 特别注意 %% *****
# 特别注意jdk版本和jvm堆内存参数，堆内存分配尽量为内存的80%，不可超过系统内存大小导致频繁swap


## 4. 启动服务
cat > /etc/init.d/zookeeper << EOF
#!/bin/bash

#chkconfig:2345 20 90
#description:zookeeper
#processname:zookeeper

case \$1 in
    start)   /home/server/zookeeper-3.4.9/bin/zkServer.sh start ;;
    stop)    /home/server/zookeeper-3.4.9/bin/zkServer.sh stop ;;
    status)  /home/server/zookeeper-3.4.9/bin/zkServer.sh status ;;
    restart) /home/server/zookeeper-3.4.9/bin/zkServer.sh restart ;;
    *)       echo "require start|stop|status|restart" ;;
esac
EOF

chmod 755 /etc/init.d/zookeeper
chkconfig zookeeper on
service zookeeper restart