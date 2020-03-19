#!/bin/bash
sudo apt-get update
sudo apt install apache2
sudo ufw allow in "Apache Full"
sudo sed -i  's/\<index.php\>/ /g'  /etc/apache2/mods-enabled/dir.conf
sudo sed -i  's/\<DirectoryIndex\>/& index.php/' /etc/apache2/mods-enabled/dir.conf
sudo apt-get install php7.2 -y
sudo apt-get install php7.2-{bcmath,bz2,intl,gd,mbstring,mysql,zip,fpm,soap,curl,json,xml} -y
sudo service php7.2-fpm reload
sudo service apache2 restart
sudo adduser ubuntu  www-data

# cd /var/www/
# git clone https://gitlab.com/Shiva_K/php-aws-codepipeline.git
# chown -R $USER:$USER /var/www/php-aws-codepipeline
sudo chmod -R 755 /var/www

sudo touch /etc/apache2/sites-available/php-aws-codepipeline.conf 
sudo echo "<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName php-aws-codepipeline
        ServerAlias www.php-aws-codepipeline
        DocumentRoot /var/www/php-aws-codepipeline
        ErrorLog \${APACHE_LOG_DIR}/php-aws-codepipeline-error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
      </VirtualHost>" >  /etc/apache2/sites-available/php-aws-codepipeline.conf 
sudo a2ensite php-aws-codepipeline.conf
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo systemctl restart apache2