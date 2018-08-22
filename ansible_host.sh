#!/bin/bash
# desc: ansible_host配置脚本

useradd gsmcupdate
echo "Agsmc999"|passwd --stdin gsmcupdate
cd /home/gsmcupdate

mkdir .ssh
touch .ssh/authorized_keys

chmod 700 .ssh
chmod 600 .ssh/authorized_keys
chown -R  gsmcupdate:gsmcupdate .ssh

sed '$assh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxDSQ7uQqzCfk5rz+fMubnV3lWauskBZ1SgzRtxQr+Ma+vnlwU0QviZYvmqLZg9QMfShH67wkpDwSYdgAl8mRPRM8KqsXdb2ZQVpU99ndX3rQrG7vgrxjp+Tk3nsV+HeuO6gauUZsxqVVouoFmFZ+ODkJQnsXW29mw2XNsWbACXxXVDxskrwx5h/89N0/r5W8Pi4g2PqKlnukZPO5q6QG7be4QlVERIreI+5kbZAdsQJUxXfMQMKIPXUjOpy5UtG0/rznjUZ7m33NldpjPfBCDt7Z39RwL8GjD/XATARZFXWttzLuVP1vBhH0wWqm3c5EqmMSSmCmjo7h/Gl77H3clw== root@localhost.localdomain' -i /home/gsmcupdate/.ssh/authorized_keys

sed '$agsmcupdate ALL=(root) NOPASSWD:/bin/kill,/bin/sh,/bin/touch,/bin/tomcat,/sbin/service,/bin/grep,/bin/ps,/bin/awk,/usr/bin/xargs,/bin/sleep,/usr/bin/rsync,/bin/cp,/bin/tar,/bin/mkdir,/bin/mv' -i /etc/sudoers
