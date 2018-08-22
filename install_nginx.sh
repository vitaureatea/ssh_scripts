#!/bin/bash
# nginx安装脚本
# 版本：1.12.1
# MD5：e8f5f4beed041e63eb97f9f4f55f3085 

download_url='http://69.172.86.99:998'
nginx_version='nginx-1.12.1'
nginx_tar=$nginx_version.tar.gz

if [ -d /usr/local/nginx ];then
  echo "Warning :nginx is existed "
else
  yum install gcc gcc-c++ cmake ncurses-devel -y
  yum install -y pcre-devel openssl openssl-devel
  cd /usr/local/src/
  [ -f $nginx_tar ] || wget $download_url/$nginx_tar
  [ $? -eq 0 ] || exit
  [ -f nginxd ] || wget $download_url/nginxd
  cp nginxd /etc/init.d/nginx
  chmod 755 /etc/init.d/nginx
  chkconfig nginx on
  
  # www账号需要找IDC组
  #groupadd www
  #useradd -g www www
  
  tar zxvf $nginx_tar
  cd $nginx_version
  ./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-http_realip_module 
  make
  make install
  echo 'export PATH=$PATH:/usr/local/nginx/sbin' > /etc/profile.d/nginx.sh
  source /etc/profile 2>&1 > /dev/null
  
  #配置文件
  cat > /usr/local/nginx/conf/nginx.conf << EOF
user www www;
worker_processes auto;

error_log /home/data/wwwlogs/error_nginx.log crit;
pid /var/run/nginx.pid;
worker_rlimit_nofile 51200;

events {
    use epoll;
    worker_connections 51200;
    multi_accept on;
    }

http {
    include mime.types;
    default_type application/octet-stream;
    large_client_header_buffers 4 32k;
    client_max_body_size 1024m;
    client_body_buffer_size 10m;
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 120;
    server_tokens off;
    tcp_nodelay on;

    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;

    #Gzip Compression
    gzip on;
    gzip_buffers 16 8k;
    gzip_comp_level 6;
    gzip_http_version 1.1;
    gzip_min_length 256;
    gzip_proxied any;
    gzip_vary on;
    gzip_types
        text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml
        text/javascript application/javascript application/x-javascript
        text/x-json application/json application/x-web-app-manifest+json
        text/css text/plain text/x-component
        font/opentype application/x-font-ttf application/vnd.ms-fontobject
        image/x-icon;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    #If you have a lot of static files to serve through Nginx then caching of the files' metadata (not the actual files' contents) can save some latency.
    open_file_cache max=1000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;

    #server{
    #        server_name _;
    #        return 404;
    #}
    access_log off;

    server_names_hash_max_size 1024;
    include vhost/include;
}
EOF
  
  mkdir -p /home/data/wwwlogs
  mkdir -p /usr/local/nginx/conf/vhost
  mkdir -p //usr/local/nginx/conf/crt
  /etc/init.d/nginx start
  echo "#################################################"
  echo "### nginx is ok, please Exit to log in again! ###"
  echo "#################################################"
fi