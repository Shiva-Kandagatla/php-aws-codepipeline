#!/bin/bash
apt-get update
apt install apache2
ufw allow in "Apache Full"
sed -i  's/\<index.php\>/ /g'  /etc/apache2/mods-enabled/dir.conf
sed -i  's/\<DirectoryIndex\>/& index.php/' /etc/apache2/mods-enabled/dir.conf
apt-get install php7.2 -y
apt-get install php7.2-{bcmath,bz2,intl,gd,mbstring,mysql,zip,fpm,soap,curl,json,xml} -y
service php7.2-fpm reload
service apache2 restart
adduser ubuntu  www-data

cd /var/www/
git clone https://gitlab.com/Shiva_K/php-aws-codepipeline.git
chown -R $USER:$USER /var/www/php-aws-codepipeline
chmod -R 755 /var/www

touch /etc/apache2/sites-available/php-aws-codepipeline.conf 
echo "<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName php-aws-codepipeline
        ServerAlias www.php-aws-codepipeline
        DocumentRoot /var/www/php-aws-codepipeline
        ErrorLog \${APACHE_LOG_DIR}/php-aws-codepipeline-error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
      </VirtualHost>" >  /etc/apache2/sites-available/php-aws-codepipeline.conf 
a2ensite php-aws-codepipeline.conf
a2dissite 000-default.conf
apache2ctl configtest
systemctl restart apache2