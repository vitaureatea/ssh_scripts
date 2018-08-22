#centos7
yum install -y iptables
yum install -y iptables-services
systemctl stop firewalld
systemctl mask firewalld

#打开网络跳转
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
#刷新
sysctl -p


#下载
yum install -y pptpd

#修改内网（localip为本机外网ip  remoteip为vpn分配的内网）
vim /etc/pptpd.conf

localip 47.90.85.135
remoteip 192.168.0.234-238

#添加账号密码
vim /etc/ppp/chap-secrets

# Secrets for authentication using CHAP
# client        server  secret                  IP addresses
test            pptpd   test123                 *


#修改dns
vim /etc/ppp/options.pptpd

ms-dns 8.8.8.8
ms-dns 8.8.4.4


#修改防火墙（-o eth1 这里eth1为外网网卡）
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth1 -j MASQUERADE

/etc/init.d/iptables save

#启动服务 centso7
systemctl start pptpd.service

# firewall rules
-A INPUT -p tcp --dport 1723 -j ACCEPT
-A INPUT -p 47 -j ACCEPT
-A OUTPUT -p 47 -j ACCEPT