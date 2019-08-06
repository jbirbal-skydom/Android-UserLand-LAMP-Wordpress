#!/bin/bash
### Start by updating, upgrading, cleaning.
apt update && apt upgrade -y
apt autoremove -y
###Install Apache
apt install apache2 -y
###Enable Rewrite Module
a2enmod rewrite
###If port 80 is taken or innaccessible without root privileges you can use 8080.
sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
###Create & Enable config to fix FQDN by setting ServerName to localhost and also configure access to directory /var/www/html/.
cat << EOF > /etc/apache2/conf-available/local.conf
ServerName localhost
<Directory /var/www/html/>
AllowOverride All
Require all granted
</Directory>
EOF
chmod u+x /etc/apache2/conf-available/local.conf
a2enconf local.conf
###Disable default dir mod and create mod that tells Apache to search for index.php first and enable.
a2dismod dir -f
cat << EOF > /etc/apache2/mods-available/phpdir.load
LoadModule dir_module /usr/lib/apache2/modules/mod_dir.so
EOF
chmod u+x /etc/apache2/mods-available/phpdir.load
cat << EOF > /etc/apache2/mods-available/phpdir.conf
<IfModule mod_dir.c>
DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF
chmod u+x /etc/apache2/mods-available/phpdir.conf
a2enmod phpdir
###Start Server
service apache2 start
###Install MySql & Configure secure installation settings.
apt install mysql-server -y
service mysql start
cat > mysql_secure_installation.sql << EOF
###Make sure that NOBODY can access the server without a password
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
###Kill the anonymous users
DELETE FROM mysql.user WHERE User='';
###disallow remote login for root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
###Kill off the demo database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
###Make our changes take effect
FLUSH PRIVILEGES;
EOF
mysql -uroot <mysql_secure_installation.sql
usermod -d /var/lib/mysql/ mysql
###Install PHP & MODULES
apt install php php-curl php-gd php-intl php-mbstring php-mysql php-soap php-xml php-xmlrpc php-zip -y
###Create info.php
cat << EOF > /var/www/html/info.php
<?php
phpinfo();
?>
EOF
chmod u+x /var/www/html/info.php
###Create & Configure php.ini
cat << EOF > /etc/php/7.2/apache2/php.ini
error_reporting = E_COMPILE_ERROR | E_RECOVERABLE_ERROR | E_ERROR | E_CORE_ERROR
max_input_time = 30
error_log = /var/log/php/error.log
upload_max_filesize = 64M
post_max_size = 32M
memory_limit = 16M
EOF
chmod u+x /etc/php/7.2/apache2/php.ini
###Create PHP Log assign ownership.
mkdir /var/log/php
chown www-data /var/log/php
### Install Common Utilities
apt install nano net-tools zip -y
### Install Common Fetchers
apt install curl git wget -y
### Install Common Compilers
apt install g++ gcc make -y
### Install Node.JS and NPM
apt install nodejs npm -y
###Start Services
service apache2 restart
service mysql restart