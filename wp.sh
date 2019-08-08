#!/bin/bash -e
###Download & Install WP-CLI.
if [ ! -f '/usr/local/bin/wp' ]; then
sudo wget -O /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo 	chmod +x /tmp/wp-cli.phar
sudo mv /tmp/wp-cli.phar /usr/local/bin/wp
fi

###Download WP.
wp core download --path=/var/www/html/wordpress/

###Create wp-config.php
wp config create --path=/var/www/html/wordpress/ --dbhost=localhost --dbname=wordpress --dbuser=root --dbpass=password

###Create MySql DB.
wp db create --path=/var/www/html/wordpress/

###Install WP.
wp core install --path=/var/www/html/wordpress/ --url=http://localhost:8080/wordpress/ --title=Example --admin_user=root --admin_password=password --admin_email=info@example.com

###Install WP Theme Understrap
wp theme install --path=/var/www/html/wordpress/ understrap

###Create and move to directory for Understrap-child.
cd /var/www/html/wordpress/wp-content/themes/

###Download and Unzip Understrap-child.
wget https://github.com/understrap/understrap-child/archive/master.zip -O temp.zip;
unzip temp.zip;
rm temp.zip

###Fix permissions
sudo chown -R www-data /var/www/html/wordpress/

###Create wordpress.conf to configure access to directory /var/www/html/wordpress/, enable & reload.
sudo cat << EOF > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
AllowOverride All
Require all granted
</Directory>
EOF
sudo chmod u+x /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress.conf
sudo service apache2 reload
