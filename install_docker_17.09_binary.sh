# install base packages
yum -y install git libcgroup libcgroup-tools
systemctl enable cgconfig;systemctl start cgconfig

# turn off selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
setenforce 0

# download and install docker
wget https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz
tar zxvf docker-17.09.0-ce.tgz
cp docker/* /usr/bin/
wget https://github.com/docker/compose/releases/download/1.17.1/docker-compose-Linux-x86_64
mv docker-compose-Linux-x86_64 /usr/bin/docker-compose
chmod 755 /usr/bin/docker-compose

# set docker env
DOCKER_USER=docker

# prepare docker systemd unit file
cat > /usr/lib/systemd/system/docker.service << EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H fd://
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

cat > /usr/lib/systemd/system/docker.socket << EOF
[Unit]
Description=Docker Socket for the API
PartOf=docker.service

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=${DOCKER_USER}

[Install]
WantedBy=sockets.target
EOF

# prepare docker group
groupadd ${DOCKER_USER}

# start docker service
systemctl daemon-reload
systemctl enable docker
