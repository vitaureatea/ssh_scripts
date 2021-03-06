### 1. 安装awx
#### step 0. 系统环境
- centos7 64位  
- python 2.7.5

#### step 1. clone repo
``` bash
git clone https://github.com/ansible/awx.git
```
#### step 2. 准备工作
安装 Ansible（Version 2.4+）
``` bash
yum install ansible -y
```
> centos7 里面的ansible版本是大于2.4的，此处安装的是2.5.5

安装 Docker  
可以参照这个安装教程：[docker installation](https://github.com/xiaotuanyu120/linux-Operation-and-maintenance-manual/blob/master/virtualization/docker/docker_1.1.0_installation_centos7.md)

安装 docker-py Python module
``` bash
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install docker
```

安装 GNU Make
``` bash
yum install make -y
```

安装 Git Requires Version 1.8.4+
参照这个安装教程: [git installation from source](https://github.com/xiaotuanyu120/linux-Operation-and-maintenance-manual/blob/master/devops/git/git_1.1.0_install.md)
``` bash
# 安装docker之后，安装docker-compose
wget https://github.com/docker/compose/releases/download/1.17.1/docker-compose-Linux-x86_64
mv docker-compose-Linux-x86_64 /usr/bin/docker-compose
chmod 755 /usr/bin/docker-compose
```

安装 Node 6.x LTS version and NPM 3.x LTS
``` bash
https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz
tar Jxvf node-v8.11.3-linux-x64.tar.xz
mv node-v8.11.3-linux-x64/ /usr/local/node

echo "export PATH=$PATH:/usr/local/node/bin" >> /etc/profile.d/node.sh
source /etc/profile

npm -v
5.6.0

node -v
v8.11.3
```

#### step 3. install awx base on docker-compose
在awx目录中有一个installer目录，
``` bash
# 默认情况下 installer/inventory 文件会把awx安装在本地，如果需要安装到其他机器，可以修改 installer/install.yml 
cd awx/
ansible-playbook -i inventory install.yml

docker ps
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                                                 NAMES
83b789355ce9        ansible/awx_task:latest      "/tini -- /bin/sh -c…"   2 minutes ago       Up 2 minutes        8052/tcp                                              awx_task
04d8601b2180        ansible/awx_web:latest       "/tini -- /bin/sh -c…"   16 minutes ago      Up 16 minutes       0.0.0.0:80->8052/tcp                                  awx_web
11ca113fbb06        memcached:alpine             "docker-entrypoint.s…"   24 minutes ago      Up 24 minutes       11211/tcp                                             memcached
f8550eeff8c2        ansible/awx_rabbitmq:3.7.4   "docker-entrypoint.s…"   25 minutes ago      Up 25 minutes       4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 25672/tcp   rabbitmq
0874fb6e43e5        postgres:9.6                 "docker-entrypoint.s…"   About an hour ago   Up About an hour    5432/tcp                                              postgres
```
> 如果install的时候卡住就手动下载一下postgres、rabbitmq、memcached、awx_task、awx_web这些镜像就不会卡住了

> 默认情况，inventory中是安装awx到localhost中，如果需要修改，可以参照[awx 官方安装教程](https://github.com/ansible/awx/blob/devel/INSTALL.md)  
inventory中还有其他的变量可以修改，例如，是否更换默认的postgres为其他的数据库，以及搭建awx在什么平台上（k8s、openshift、docker原生、docker compose）