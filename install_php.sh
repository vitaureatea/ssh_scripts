#!/bin/bash
# desc: php安装脚本


# 环境变量
INSTALL_DIR=/usr/local/src
PHP_GET_URL=http://69.172.86.99:998
PHP_VER=7.1.2
PHP_DIR=/usr/local/php
PHP_USER=www
PHP_GROUP=www

# 创建用户和用户组
function createuse() {
  groupadd ${PHP_USER}
  useradd -g ${PHP_GROUP} ${PHP_USER}
}

# 安装PHP
function installphp() {
  cd $INSTALL_DIR
  rm -rf php-${PHP_VER}.tar.gz
  rm -rf php-${PHP_VER}
  wget ${PHP_GET_URL}/php-${PHP_VER}.tar.gz
  tar zxvf php-${PHP_VER}.tar.gz
  cd php-${PHP_VER}

  yum install -y gcc gcc-c++ cmake ncurses-devel epel-release
  yum install -y libmcrypt-devel libxslt-devel curl-devel libjpeg-turbo-devel libxml2-devel libcurl-devel libjpeg-turbo-devel libpng-devel freetype-devel php-mcrypt libevent-devel openssl-devel libicu-devel
  ./configure  --prefix=${PHP_DIR} --with-config-file-path=${PHP_DIR}/etc --with-config-file-scan-dir=${PHP_DIR}/etc/php.d --with-fpm-user=${PHP_USER} --with-fpm-group=${PHP_USER} --enable-fpm --enable-opcache --disable-fileinfo --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-exif --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-ftp --enable-intl --with-xsl --with-gettext --enable-zip --enable-soap --disable-debug
  make
  make install
  installconfig
}

# 拷贝配置文件及守护脚本
function installconfig() {
  cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
  chmod +x /etc/init.d/php-fpm
  echo ';;;;;;;;;;;;;;;;;;;;;
; FPM Configuration ;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
; Global Options ;
;;;;;;;;;;;;;;;;;;

[global]
pid = run/php-fpm.pid
error_log = log/php-fpm.log
log_level = warning

emergency_restart_threshold = 30
emergency_restart_interval = 60s
process_control_timeout = 5s
daemonize = yes

;;;;;;;;;;;;;;;;;;;;
; Pool Definitions ;
;;;;;;;;;;;;;;;;;;;;

[www]
listen = /tmp/php-fpm.sock 
listen.backlog = -1
listen.allowed_clients = 127.0.0.1
listen.owner = www
listen.group = www
listen.mode = 0666
user = www
group = www

pm = static
pm.max_children = 60
pm.start_servers = 60
pm.min_spare_servers = 50
pm.max_spare_servers = 80
pm.max_requests = 2048
pm.process_idle_timeout = 10s
request_terminate_timeout = 120
request_slowlog_timeout = 3s
access.log = /usr/local/php/var/log/pool.access.log
access.format = "%R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%%"
slowlog = /usr/local/php/var/log/slow.log' > ${PHP_DIR}/etc/php-fpm.conf


  echo '[PHP]
engine = On
short_open_tag = On
precision = 14
output_buffering = On
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
unserialize_callback_func =
serialize_precision = -1
disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen
disable_classes =
realpath_cache_size = 2M
zend.enable_gc = On
expose_php = Off
max_execution_time = 600
max_input_time = 60
memory_limit = 448M
error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = Off
display_startup_errors = Off
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
track_errors = Off
html_errors = On
variables_order = "GPCS"
request_order = "CGP"
register_argc_argv = Off
auto_globals_jit = On
post_max_size = 100M
auto_prepend_file =
auto_append_file =
default_mimetype = "text/html"
default_charset = "UTF-8"
doc_root =
user_dir =
enable_dl = Off
cgi.fix_pathinfo=0
file_uploads = On
upload_max_filesize = 50M
max_file_uploads = 20
allow_url_fopen = On
allow_url_include = Off
default_socket_timeout = 60
[CLI Server]
cli_server.color = On
[Date]
date.timezone = Asia/Shanghai
[filter]
[iconv]
[intl]
[sqlite3]
[Pcre]
[Pdo]
[Pdo_mysql]
pdo_mysql.cache_size = 2000
pdo_mysql.default_socket=
[Phar]
[mail function]
SMTP = localhost
smtp_port = 25
sendmail_path = /usr/sbin/sendmail -t -i
mail.add_x_header = On
[SQL]
sql.safe_mode = Off
[ODBC]
odbc.allow_persistent = On
odbc.check_persistent = On
odbc.max_persistent = -1
odbc.max_links = -1
odbc.defaultlrl = 4096
odbc.defaultbinmode = 1
[Interbase]
ibase.allow_persistent = 1
ibase.max_persistent = -1
ibase.max_links = -1
ibase.timestampformat = "%Y-%m-%d %H:%M:%S"
ibase.dateformat = "%Y-%m-%d"
ibase.timeformat = "%H:%M:%S"
[MySQLi]
mysqli.max_persistent = -1
mysqli.allow_persistent = On
mysqli.max_links = -1
mysqli.cache_size = 2000
mysqli.default_port = 3306
mysqli.default_socket =
mysqli.default_host =
mysqli.default_user =
mysqli.default_pw =
mysqli.reconnect = Off
[mysqlnd]
mysqlnd.collect_statistics = On
mysqlnd.collect_memory_statistics = Off
[OCI8]
[PostgreSQL]
pgsql.allow_persistent = On
pgsql.auto_reset_persistent = Off
pgsql.max_persistent = -1
pgsql.max_links = -1
pgsql.ignore_notice = 0
pgsql.log_notice = 0
[bcmath]
bcmath.scale = 0
[browscap]
[Session]
session.save_handler = files
session.use_strict_mode = 0
session.use_cookies = 1
session.use_only_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain =
session.cookie_httponly =
session.serialize_handler = php
session.gc_probability = 1
session.gc_divisor = 1000
session.gc_maxlifetime = 1440
session.referer_check =
session.cache_limiter = nocache
session.cache_expire = 180
session.use_trans_sid = 0
session.sid_length = 26
session.trans_sid_tags = "a=href,area=href,frame=src,form="
session.sid_bits_per_character = 5
[Assertion]
zend.assertions = -1
[COM]
[mbstring]
[gd]
[gd]
[exif]
[Tidy]
tidy.clean_output = Off
[soap]
soap.wsdl_cache_enabled=1
soap.wsdl_cache_dir="/tmp"
soap.wsdl_cache_ttl=86400
soap.wsdl_cache_limit = 5
[sysvshm]
[ldap]
ldap.max_links = -1
[mcrypt]
[dba]
[opcache]
[curl]
[openssl]' > ${PHP_DIR}/etc/php.ini
  mkdir -p ${PHP_DIR}/log/
}


if [ -d "$PHP_DIR" ];then
  echo "php dir already exist!"
else
  createuse
  installphp
fi
