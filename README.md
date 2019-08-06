# Android-UserLand-LAMP-Wordpress
Scripts to set up a LAMP stack plus WordPress on Android with Ubuntu using the [UserLand](https://github.com/CypherpunkArmory/UserLAnd) no root required.

1. Start by installing Ubuntu on UserLand.

2. Place Scripts into Ubuntu using one of the methods from the [UserLand Wiki](https://github.com/CypherpunkArmory/UserLAnd/wiki/Importing-and-exporting-files-in-UserLAnd).

3. Connect and login to Ubuntu.

4. Now Run the scripts using the following commands.

```
sudo bash fixscripts.sh
```
This first script is optional but was necessary for me as I edited the scripts on an Android text editor and needed to reformat the scripts in order to run correctly on Ubuntu.

```
sudo bash upgrade.sh
```
This script is also optional but will upgrade Bionic to Disco which was necessary for me to get the Node.JS and NPM my project required.
```
sudo bash lamp.sh
```
This script starts by downloading and configuring Apache to run on [http://localhost:8080/](http://localhost:8080/).

*This is because port 80 isn't available without a rooted device.*

Then it downloads and configures MySql, creates a user named "root" for it with the password "password" then creates a database named wordpress and grants user "root" access to it allowing the wp.sh script to run correctly.

It finishes by downloading and configuring PHP and some other common fetchers, compilers, and utilities.

```
bash wp.sh
```
*This script is run without the "sudo" command as WP-CLI doesn't encourage running commands with root permissions.*

This script installs and configures WordPress with a usernamed "root" and password "password" it connects to the database and creates the table. 

For convenience it also installs the Understrap and Understrap Child-Themes.

The following commands will start the services.
```
service apache2 start
```
```
sudo service MySQL start
```
You can now see the WordPress frontpage at [http://localhost:8080/wordpress/](http://localhost:8080/wordpress/)

You can now login to WordPress using "root" and "password" by going to [http://localhost:8080/wordpress/wp-login.php](http://localhost:8080/wordpress/wp-login.php).

