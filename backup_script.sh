#/bin/bash  
set -e

#############
# SET ENV
#############
# set absolute path to target
BAK_SRC_TARGET=/tmp/test
# set absolute path to destnation of bakfile
BAK_DEST_DIR=/tmp/test_bak
# set how many days of bakfile need to keep
BAK_COPY_KEEPDAYS=
# bak time
BAK_TIME=`date +%Y%m%d-%H%M%S`


#############
# CHECK ENV
#############
# check BAK_SRC_TARGET exists or not
[[ -e "$BAK_SRC_TARGET" ]] && {
  BAK_SRC_BASE=`dirname $BAK_SRC_TARGET`
  BAK_SRC_FILE=`basename $BAK_SRC_TARGET`
} || {
  exit 1
}

# check BAK_DEST_DIR exists or not
[[ ! -d "$BAK_DEST_DIR" ]] && {
  mkdir -p $BAK_DEST_DIR
}

# set BAK_COPY_KEEPDAYS 30 if its empty
[[ -z "$BAK_COPY_KEEPDAYS" ]] && BAK_COPY_KEEPDAYS=30


#############
# BACKUP
#############
# change directory to BAK_SRC_BASE to ensure that we just package objective path
cd $BAK_SRC_BASE
# package and zip BAK_SRC_FILE
tar zcf ${BAK_SRC_FILE}.${BAK_TIME}.tar.gz ${BAK_SRC_FILE}
xz ${BAK_SRC_FILE}.${BAK_TIME}.tar.gz

# move bak file to BAK_DEST_DIR
mv ${BAK_SRC_FILE}.${BAK_TIME}.tar.gz.xz $BAK_DEST_DIR


#############
# CLEAR BACKUP FILE
#############
find $BAK_DEST_DIR -name "${BAK_SRC_FILE}.*" -mtime +$BAK_COPY_KEEPDAYS | xargs -i rm -rf {}