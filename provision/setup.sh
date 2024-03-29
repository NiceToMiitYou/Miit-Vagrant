#!/bin/bash

echo "Provisioning virtual machine..."

# Configure Shell
export DEBIAN_FRONTEND=noninteractive 
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Configure Language
locale-gen en_US.UTF-8      
dpkg-reconfigure locales    

# Git
echo "Installing Git..."
apt-get install git -y 

# Nginx
echo "Installing Nginx..."
apt-get install nginx -y 

# PHP
echo "Updating repository..."
apt-get install python-software-properties build-essential -y 

echo "Installing PHP..."
apt-get install php5-common php5-dev php5-cli php5-fpm -y 

echo "Installing PHP extensions..."
apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql php5-mongo php5-xdebug php-apc -y 

echo "Configuring XDebug..."
echo '

# Time Zone
date.timezone = "Europe/Paris"

# Added for xdebug
zend_extension="/usr/lib/php5/20100525/xdebug.so"
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=0.0.0.0
xdebug.remote_port=2331
xdebug.profiler_enable=0
xdebug.profiler_enable_trigger=1
xdebug.profiler_output_name="cachegrind.out.%t.%p"

' >> /etc/php5/fpm/php.ini 

echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# MySQL
echo "Preparing MySQL..."
apt-get install debconf-utils -y 
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "Installing MySQL..."
apt-get install mysql-server -y 

# MongoDB 
echo "Installing MongoDB..."
apt-get install mongodb-server -y

echo "Configuring MongoDB..."
sed -i 's/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/g' /etc/mongodb.conf

# Nginx Configuration
echo "Configuring Nginx..."
cp /var/www/provision/config/nginx_vhost /etc/nginx/sites-available/nginx_vhost 
ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/

rm -rf /etc/nginx/sites-available/default

# Restart Nginx for the config to take effect
service nginx restart 

echo "Finished provisioning."