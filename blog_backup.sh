#!/bin/bash
#DESCRIPTION:1、备份乐虎数据库、源码并删除5天前的备份。
#AUTHOR&DATE:francis-20161228

echo -e "\033[31;15m---------------------------\033[0m"
echo -e "\033[31;1m开始运行博客数据库备份脚本：\033[0m"
echo -e "\033[31;15m---------------------------\033[0m"

#定义变量(数据库用户、密码以及备份目录)
DB_USER=root
DB_PWD='adminmysql'
DB_NAME=("bbs" "ultrax" "ultrax_boss" "ultrax_9an" "ultrax_99")
BACKUP_PATH=/home/BACKUP/db
BACKUP_DATE=`date +%Y%m%d-%H%M%S`

CODE_SRCPATH=/data/www
CODE_DESTPATH=/home/BACKUP/code
#CODE_NAME=("BBS.9security.com" "BBS.lachain.io" "BBS.swipetoken.org" "bbs.veetech.io" "99_gsmc")
CODE_NAME=("99_gsmc"  "BBS.9security.com"  "BBS.lachain.io"  "BBS.swipetoken.org"  "bbs.veetech.io")

#创建备份目录
if [ ! -e $BACKUP_PATH ] || [ ! -e $CODE_DESTPATH ];then
        echo -e "\033[33m创建备份目录/home/BACKUP......\033[0m"
        /bin/mkdir -p $BACKUP_PATH $CODE_DESTPATH > /dev/null 2>&1
        echo -e "\033[33m备份目录/home/BACKUP创建完成！\n\033[0m"
fi

#备份博客数据库并删除
for BACKUP_DB in ${DB_NAME[@]};do
        echo "开始备份数据库-$BACKUP_DB......"
        /usr/local/mysql/bin/mysqldump -u$DB_USER -p$DB_PWD $BACKUP_DB > $BACKUP_PATH/$BACKUP_DB-$BACKUP_DATE.sql
        #echo $BACKUP_PATH/$BACKUP_DB-$BACKUP_DATE.sql
        echo -e "\033[33m$BACKUP_DB库备份完成！\033[0m"
        echo "--------------------"
done

/bin/find $BACKUP_PATH -type f -name "*.sql" -mtime +30 |xargs rm -rf

echo -e "\033[31;15m---------------------------\033[0m"
echo -e "\033[31;1m开始运行博客源码备份脚本：\033[0m"
echo -e "\033[31;15m---------------------------\033[0m"

#清理临时文件
#echo
#echo "开始清理临时文件......"
#sleep 3
#TMP_FILE=/home/Webser
#/bin/rm -rf $TMP_FILE/bbs.lehubbs.com/uc_server/data/tmp/*

#同步乐虎图片
#echo
#echo "开始同步图片文件......"
#sleep 5
#COMM_RSYNC=`which rsync`
#IMAGE_SRC=/data/www/bbs.veetech.io
#IMAGE_DEST=/home/BACKUP/code/images/
#IMAGE_PATH1=data/attachment/forum/
#IMAGE_PATH4=data/appbyme/thumb/
#$COMM_RSYNC -auv $IMAGE_SRC/$IMAGE_PATH1 $IMAGE_DEST/$IMAGE_PATH1
#$COMM_RSYNC -auv $IMAGE_SRC/$IMAGE_PATH2 $IMAGE_DEST/$IMAGE_PATH2
#$COMM_RSYNC -auv $IMAGE_SRC/$IMAGE_PATH3 $IMAGE_DEST/$IMAGE_PATH3
#$COMM_RSYNC -auv $IMAGE_SRC/$IMAGE_PATH4 $IMAGE_DEST/$IMAGE_PATH4

#备份博客源码并删除
cd $CODE_SRCPATH
for BACKUP_CODE in ${CODE_NAME[@]};do
        echo
        echo "开始备份源码-$BACKUP_CODE......"
        sleep 3
        #/bin/tar zcf $BACKUP_CODE-$BACKUP_DATE.tar.gz $BACKUP_CODE/
        #/bin/mv $BACKUP_CODE-$BACKUP_DATE.tar.gz $CODE_DESTPATH
        /bin/cp -R $BACKUP_CODE $CODE_DESTPATH/$BACKUP_CODE-$BACKUP_DATE.bak
       /usr/bin/rsync -vzacu  $BACKUP_CODE /home/BACKUP/new/$BACKUP_CODE.bak
     #   rsync -a --exclude="data/attachment/forum" --exclude="uc_server/data/avatar/000" --exclude="data/attachment/image/000" --exclude="data/appbyme/thumb" $BACKUP_CODE $CODE_DESTPATH/$BACKUP_CODE-$BACKUP_DATE.bak
        echo -e "\033[33m$BACKUP_CODE源码备份完成！\033[0m"
        echo "--------------------"
done

/bin/find $CODE_DESTPATH -type d -name "*.bak" -mtime +15 |xargs rm -rf

