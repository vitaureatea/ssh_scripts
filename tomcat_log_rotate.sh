#!/bin/bash
log_file=()
date_str=`date +%Y%m%d-%H%M%S`
days_bakfile_will_keep=10

# 备份
for i in ${log_file[@]};
do
    mv ${i} ${i}-${date_str}
    touch ${i}
done

# 删除大于${days_bakfile_will_keep}天的备份
for i in ${log_file[@]};
do
    find `dirname ${i}` -name "`basename ${i}`-*" -mtime +${days_bakfile_will_keep} | xargs -i rm -rf {}
done