### redis哨兵集群 （以EQ机房为例子）
|安装软件|外网ip|内网ip|备注|
|---|---|---|---|
|哨兵	|220.241.124.178|172.23.2.78|
|哨兵	|220.241.124.179|172.23.2.79|
|哨兵-redis|  220.241.124.180|172.23.2.80|主
|哨兵-redis|  220.241.124.181|172.23.2.81|副
|哨兵-redis|  220.241.124.152|172.23.2.52|副

###redis主配置
```
bind 0.0.0.0
protected-mode yes
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile "/var/run/redis_6379.pid"
loglevel notice
logfile "/var/log/redis/redis_6379.log"
databases 16
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename "dump_6379.rdb"
dir "/opt/redis"
masterauth "redismiddleservice2017!@#"
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
requirepass "redismiddleservice2017!@#"
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
slave-lazy-flush no
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble no
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
```
###redis副配置
```
bind 0.0.0.0
protected-mode yes
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile "/var/run/redis_6379.pid"
loglevel notice
logfile "/var/log/redis/redis_6379.log"
databases 16
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename "dump_6379.rdb"
dir "/opt/redis"
masterauth "redismiddleservice2017!@#"
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
requirepass "redismiddleservice2017!@#"
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
slave-lazy-flush no
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble no
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
slaveof 172.23.2.80 6379
```
### 5个哨兵配置
```
bind 0.0.0.0
protected-mode no
daemonize yes
port 26379
loglevel notice
logfile "/var/log/redis/sentinel.log"
sentinel monitor mymaster 172.23.2.80 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 8000
sentinel auth-pass mymaster redismiddleservice2017!@#
sentinel parallel-syncs mymaster 1
```
### 最后
配置好了重启即可，防火墙配置，在主写入，在从查看是否存在key即可
