clear
cp /tmp/wgetrc /root/.wgetrc
cp /tmp/wgetrc /home/frdbecc

echo "## Récupération de tous les packages ##"
apt-get update > /dev/null
apt-get install -y sudo apt-show-versions build-essential ufw vim git libpcre3 libpcrecpp0 libssl-dev zlib1g-dev unattended-upgrades apache2-threaded-dev libxml2-dev  libxml2 libxml2-dev libxml2-utils libaprutil1 libaprutil1-dev automake autoconf libtool libpcre3-dev > /dev/nul

echo "## Suppression des packages inutiles ##"
apt-get -y purge rpcbind* exim4* telnet ftp > /dev/null
apt-get -y autoremove > /dev/null

echo "## Paramétrage de Git ##"
git config --global user.name "administrateur"
git config --global user.email "administrateur@nowhere.fr"
git config --global http.proxy http://benoit_durand:PhnazWTJ@10.49.64.5:8080
git config --global https.proxy http://benoit_durand:PhnazWTJ@10.49.64.5:8080

echo "## Désactiver l'ip V6"
echo net.ipv6.conf.all.disable_ipv6=1 | tee -a /etc/sysctl.conf
echo net.ipv6.conf.all.autoconf=0 | tee -a /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6=1 | tee -a /etc/sysctl.conf
echo net.ipv6.conf.default.autoconf=0 | tee -a /etc/sysctl.conf

echo "## Pour les caractères accentués dans le terminal ##"
echo "LANG=fr_FR.UTF-8" | tee -a /etc/environment > /dev/nul
echo 'LANGUAGE="fr_FR.UTF-8"' | tee -a /etc/environment > /dev/nul
echo "LC_ALL=fr_FR.UTF-8" | tee -a /etc/environment > /dev/nul

echo "## Configuration de unattended ##"
echo 'APT::Periodic::Update-Package-Lists "1";' |  tee -a  /etc/apt/apt.conf.d/20auto-upgrades > /dev/null
echo 'APT::Periodic::Unattended-Upgrade "1";' |  tee -a  /etc/apt/apt.conf.d/20auto-upgrades > /dev/null

echo "## Rajout de l'utilisateur dans r ##"
usermod -a -G sudo frdbecc
#sed -i -e "/# User privilege specification/a\frdbecc    ALL=(ALL:ALL) ALL" '/etc/sudoers'

echo "## Sécurisation avec le firewall UFW ##"
service ufw start
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable

echo "## Compilation et Installation de MODSECURITY pour NGINX"
git clone https://github.com/SpiderLabs/ModSecurity.git mod_security
cd mod_security
./autogen.sh
./configure --enable-standalone-module
make
cd ..

echo "## Compilation et installation de NGINX ##"
wget http://nginx.org/download/nginx-1.11.5.tar.gz
tar -zxvf nginx-1.11.5.tar.gz  > /dev/null
cd nginx-1.11.5
./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-debug --with-pcre --with-http_ssl_module --with-http_v2_module --without-http_geo_module --add-module=../mod_security/nginx/modsecurity  > /dev/null

make  > /dev/null
make install  > /dev/null

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled
mkdir /etc/nginx/conf.d
mkdir /var/www
chown frdbecc:frdbecc /var/www
cd /tmp

echo "<?php echo 'It's Works !!; ?>" > /var/www/index.php
cp /tmp/nginx.config /etc/nginx/nginx.conf
cp /tmp/unicode.mapping /etc/nginx/
cp /tmp/modsecurity.conf /etc/nginx/
cp /tmp/test.fr /etc/nginx/sites-available/test.fr
ln -s /etc/nginx/sites-available/test.fr /etc/nginx/sites-enabled/test.fr
cp /tmp/nginx.sh /etc/init.d/nginx.sh
chmod +x /etc/init.d/nginx.sh
update-rc.d -f nginx.sh defaults
service nginx restart

echo "## Installation de PERCONA MYSQL 5.7 ##"
wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
apt-get update > /dev/null
echo "percona-server-server-5.7 mysql-server/root_password password mvCDECww" | debconf-set-selections
echo "percona-server-server-5.7 mysql-server/root_password_again password mvCDECww" | debconf-set-selections
apt-get install -q -y percona-server-server-5.7
sed -i -e 's/^#slow_query_log/slow_query_log/' /etc/mysql/my.cnf
sed -i -e 's/^#long_query_time/long_query_time/' /etc/mysql/my.cnf
sed -i -e 's/^#long_query_time = 2/long_query_time = 10/' /etc/mysql/my.cnf
sed -i -e 's/^#log_queries_not_using_indexes/log_queries_not_using_indexes/' /etc/mysql/my.cnf

echo "## Installation de PHP7 ##"
echo "deb http://dotdeb.thefox.com.fr jessie all" | tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null
echo "deb-src http://dotdeb.thefox.com.fr jessie all" | tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null
echo "deb http://packages.dotdeb.org jessie all" | tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null
echo "deb-src http://packages.dotdeb.org jessie all" | tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null
echo "deb http://packages.dotdeb.org jessie all" | tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null
echo "deb-src http://packages.dotdeb.org jessie all" | tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null

wget https://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg
apt-get update > /dev/null
echo "## Téléchargement de PHP 7 ##"
apt-get install -y php7.0-gd php7.0-mysql php7.0-bz2 php7.0-json php7.0-curl php7.0-cli php7.0-mbstring php7.0-mcrypt php7.0-odbc php7.0-opcache php7.0-fpm > /dev/null
sed -i -e 's/[;]cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*expose_php =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini

echo "PHP error handling"
sed -i -e 's/\(.*error_reporting =\).*$/\1 E_ALL/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*display_errors =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*display_startup_errors =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*log_errors =\).*$/\1 On/' /etc/php/7.0/fpm/php.ini
sed -i -e "/log_errors_max_len/a\log_errors = \/var\/log\/php\/php_errors.log" /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*ignore_repeated_errors =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini

echo "PHP some more security settings"
sed -i -e 's/\(.*memory_limit =\).*$/\1 32M/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*post_max_size =\).*$/\1 32M/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*max_execution_time =\).*$/\1 60/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*report_memleaks =\).*$/\1 On/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*track_errors =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*html_errors =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*allow_url_fopen =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*allow_url_include =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*variables_order =\).*$/\1 "GPSE"/' /etc/php/7.0/fpm/php.ini
sed -i -e "/variables_order/a\allow_webdav_methods = Off" /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*allow_webdav_methods =\).*$/\1 Off/' /etc/php/7.0/fpm/php.ini
sed -i -e 's/\(.*disable_functions =\).*$/\1 system, exec, shell_exec, passthru, phpinfo, show_source, popen, proc_open, fopen_with_path, dbmopen, dbase_open, putenv, move_uploaded_file, chdir, mkdir, rmdir, chmod, rename, filepro, filepro_rowcount, filepro_retrieve, posix_mkfifo/' /etc/php/7.0/fpm/php.ini

sed -i -e 's/listen = \/run\/php\/php7.0-fpm.sock/listen = 127.0.0.1:9000/' /etc/php/7.0/fpm/pool.d/www.conf
service php7.0-fpm restart

echo "## Mise à jour du système avant reboot ##"
apt-get update && apt-get upgrade && apt-get dist-upgrade -y > /dev/null

echo "## Installation terminée ##"
