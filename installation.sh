#!/bin/bash -x

# Load Terraform variables from vars.tfvars
source vars.tfvars

sudo yum update -y 

sudo amazon-linux-extras enable php8.2

#install php
sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd -y

sudo yum install -y php-cli php-common php-json php-gd php-mbstring php-intl php-mysqlnd php-xml php-opcache

php -v

sleep 10

#install httpd and mysql 
sudo yum install -y httpd php php-mysqlnd mysql-server

sudo systemctl enable httpd --now

sudo yum install -y mariadb-server

sudo systemctl enable mariadb --now

sudo systemctl status mariadb

sleep 10

#setting permissions for files 

groups
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

sleep 10

# check if everything is running 
sudo systemctl status httpd
php -v
sudo systemctl status mariadb

sleep 10

#INSTALL WORDPRESS in /var/www/html/

cd /var/www/html/

wget https://wordpress.org/latest.tar.gz

tar -xzf latest.tar.gz

sudo chown -R apache:apache /var/www/html/wordpress

sleep 10

#INSTALL REDIS 

sudo amazon-linux-extras install epel -y
sudo yum install redis -y
sudo systemctl start redis
sudo systemctl enable redis
sudo systemctl status redis

sleep 30

# mounting efs - attach to wordpress config file folder = /var/www/html

sudo mkdir /efs

sleep 20

# sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${dns_name}:/ /efs"
# sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${dns_name}:/ /var/www/html"
  sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${dns_name}:/ /efs"


# test mount 
df -h

sleep 10

# check if rds webpage is working or not:
nslookup  ${rds_endpoint}

# Check if the database exists before creating or deleting it
if mysql -h wp-rds.cu7mlqnxm9in.us-east-1.rds.amazonaws.com -P 3306 -u admin -p1234qwer -e "USE wordpressdb11"; then
  # The database exists, so delete it first
  mysql -h wp-rds.cu7mlqnxm9in.us-east-1.rds.amazonaws.com -P 3306 -u admin -p1234qwer <<MYSQL_SCRIPT
  DROP DATABASE wordpressdb11;
MYSQL_SCRIPT

  echo "Database 'wordpressdb11' deleted successfully."
fi

# Now, create the database
mysql -h wp-rds.cu7mlqnxm9in.us-east-1.rds.amazonaws.com -P 3306 -u admin -p1234qwer <<MYSQL_SCRIPT
CREATE DATABASE wordpressdb11;
MYSQL_SCRIPT

echo "Database 'wordpressdb11' created successfully."