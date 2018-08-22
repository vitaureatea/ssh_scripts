curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.4-x86_64.rpm
rpm -vi filebeat-6.2.4-x86_64.rpm

vim /etc/filebeat/filebeat.yml
*************************************************
filebeat.prospectors:
- type: log
  enabled: true
  paths:
    - /home/middleservice/e68_midd/logs/catalina.out
  fields:
    service: e68_midd
    log_topic: filebeat-midd
  multiline.pattern: '^[[:space:]]+(at|\.{3})\b|^Caused by:'
  multiline.negate: false
  multiline.match: after

filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 3

name: 86.105
tags: ["middleservice", "e68"]
output.kafka:
  # initial brokers for reading cluster metadata
  hosts: ["69.172.86.138:9092", "69.172.86.138:9093", "47.91.153.74:9092"]

  # message topic selection + partitioning
  topic: '%{[fields.log_topic]}'
  partition.round_robin:
    reachable_only: false

  required_acks: 1
  compression: gzip
  max_message_bytes: 1000000
*************************************************