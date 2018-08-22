#/bin/bash

# 1. remove old version
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# 2. install utils and repo
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --disable docker-ce-edge

# 3. install docker-ce-17.03.2
# install docker-ce-selinux first
yum install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm -y
yum install docker-ce-17.03.2.ce -y

# 4. install docker-compose
wget https://github.com/docker/compose/releases/download/1.17.1/docker-compose-Linux-x86_64
mv docker-compose-Linux-x86_64 /usr/bin/docker-compose
chmod 755 /usr/bin/docker-compose