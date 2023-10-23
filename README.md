## Deploy Website with GitHub Actions and Terraform

## Objective:


## Architectural Diagram: 
![Alt text](<architectural diagram - 1.png>)

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | ~> 3.0  | 


## Providers

| Name | Version |
| ---- | ------- |
| aws  | ~> 3.0  |

## Inputs

| Name         | Description                                                                                           | Type           | Default | Required |
| ------------ | ----------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| aws_region   | Name of AWS region in which you want to create the resource.                                          | `string`       | ""      |   yes    |
| instance_name1  | A unique name for NAT instance.                                                                        | `string`       | ""      |   yes    |
| instance_name2  | A unique name for master instance.                                                                              | `string`       | ""      |   yes    |
| instance_type1   | Select an instance type for the NAT instance.                                | `string`       | ""      |   yes    |
| instance_type2 | Select an instance type for the Master instance.                                   | `string`       | ""      |   yes    |
| ami_id | Select an instance image.                                                 | `string`       | ""      |   yes    |
| subnet_cidr_a  | Enable if bucket versioning is required.                                                        | `string`         | "False" |   yes    |CIDR block for Subnet A
| subnet_cidr_b | CIDR block for Subnet B                                                   | `string`       | ""      |   yes    |
| subnet_cidr_c   | CIDR block for Subnet C                                          | `string`       | ""      |   yes    |
| subnet_cidr_d  | CIDR block for Subnet D                                                                       | `string`       | ""      |   yes    |
| subnet_cidr_e  | CIDR block for Subnet E                                                                             | `string`       | ""      |   yes    |
| subnet_cidr_f | CIDR block for Subnet F                                  | `string`       | ""      |   yes    |
| route_table_name1 | A unique name for the Public Route table.                                                | `string`       | ""      |   yes    |
| route_table_name2  | A unique name for the Private Route table.                                                        | `string`         | "True"  |   yes    |
| internet_gateway_name  | A unique name for the Internet gateway.                                                        | `string`         | "False" |   yes    |
| efs_name | A unique name for the elastic file system.                                                      | `string`       | ""      |   yes    |
| performance_mode  | Type of performance mode required.                                                                        | `string`       | ""      |   yes    |
| throughput_mode  | Type of throughput mode required.                                                                           | `string`       | ""      |   yes    |
| db_name   | A unique name for the Relational Database Server instance/database.                                | `string`       | ""      |   yes    |
| db_username | A username for sequrity purposes.                                   | `string`       | ""      |   yes    |
| db_password | A password for security purposes.                                               | `string`       | ""      |   yes    |
| cluster_id  | A unique name for the Elasticache redis - cluster,                                                        | `string`         | "True"  |   yes    |
| engine_version | An engine version for the redis cluster.                                                      | `string`       | ""      |   yes    |
| subnet_group_name  | A subnet group name for the redis cluster.                                                        | `string`         | "False" |   yes    |
| node_type | A node type for the redis cluster.                                                      | `string`       | ""      |   yes    |

## Steps to Create Terraform Code for Infrastructure Automation:
- Terraform Installation (Skip if already done):
- Terraform is an infrastructure-as-code tool used to define and provision infrastructure resources. Ensure Terraform is installed on your
local machine or the GitHub Actions runner.
- If using GitHub Actions, the installation step for Terraform can be seen in the provided workflow file.
Create Terraform Configuration Files:
- In the root directory of your GitHub repository, create a new directory (e.g., terraform) to store the Terraform configuration files.



## Steps to Create Terraform Code for Infrastructure Automation:
### 1. Initialize Terraform
```hcl
terraform init
```
### 2. Provision AWS Resources

```hcl
terraform apply --var-file=vars.tfvars
```

### This will provision the following resources:

i> VPC (Virtual Private Cloud): 
VPC is Amazon's networking service that allows you to create a logically isolated section of the AWS Cloud where you can launch AWS resources, providing control over your network configuration.

ii> EC2 (Elastic Compute Cloud): 
EC2 is a web service that provides resizable compute capacity in the cloud, allowing you to run virtual servers known as instances for various applications.

iii> EFS (Elastic File System): 
EFS is a scalable and managed file storage service that can be shared across multiple EC2 instances, providing a common file system for applications.

iv> RDS (Relational Database Service): 
RDS is a managed database service that simplifies the setup, operation, and scaling of relational databases, such as MySQL, PostgreSQL, and others.

v> ElastiCache Redis: 
ElastiCache is a managed in-memory data store service that provides a highly available and scalable Redis caching solution for improving application performance.

vi> Autoscaling: 
Autoscaling is a service that automatically adjusts the number of EC2 instances in your Auto Scaling group to maintain application availability and performance.

vii> Load Balancing: 
Load balancing is the process of distributing incoming network traffic across multiple EC2 instances or resources to ensure high availability and fault tolerance for your applications.

### 3. Step to Configure: 

* ## Installing LAMP Stack : A LAMP stack is a commonly used software bundle for building and deploying web applications, including WordPress. The acronym LAMP stands for:
 i> Linux: Linux serves as the foundational operating system.It hosts all other components and manages server resources.
 ii> Apache: Apache is the web server that handles HTTP requests. It serves web pages, including WordPress sites, and can be automated for setup with tools like Ansible or Terraform.
 iii> MySQL: MySQL is the database system for storing WordPress content.Automation creates databases, users, and permissions for WordPress data.
 iv> PHP: PHP is the scripting language WordPress is built on. Automation installs and configures PHP with required settings and extensions for WordPress.

    1. SSH into your server:

    Connect to your server where you want to install LAMP Stack. You can use SSH for Linux-based systems.
    
    2. PErform initial update :  

    sudo yum update -y 

    sudo amazon-linux-extras enable php8.2

    3. install php
    sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd -y

    sudo yum install -y php-cli php-common php-json php-gd php-mbstring php-intl php-mysqlnd php-xml php-opcache

    php -v

    4. install httpd and mysql 
    sudo yum install -y httpd php php-mysqlnd mysql-server

    sudo systemctl enable httpd --now

    sudo yum install -y mariadb-server

    sudo systemctl enable mariadb --now

    sudo systemctl status mariadb

    5. setting permissions for files 

    groups
    sudo usermod -a -G apache ec2-user
    sudo chown -R ec2-user:apache /var/www
    sudo chmod 2775 /var/www
    find /var/www -type d -exec sudo chmod 2775 {} \;
    find /var/www -type f -exec sudo chmod 0664 {} \;
    echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

    6.  check if everything is running 
    sudo systemctl status httpd
    php -v
    sudo systemctl status mariadb

    7. INSTALL WORDPRESS in /var/www/html/

    cd /var/www/html/
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    sudo chown -R apache:apache /var/www/html/wordpress

    8. INSTALL REDIS 
    sudo amazon-linux-extras install epel -y
    sudo yum install redis -y
    sudo systemctl start redis
    sudo systemctl enable redis
    sudo systemctl status redis

    9.  mounting efs - attach to wordpress config file folder = /var/www/html
    sudo mkdir /efs
    sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport  EFS-DNS NAME:/ /efs 
    df -h

    10. Create a database. 
    mysql -h {RDS-ENDPOINT} -P 3306 -u {DATABASE USERNAME} -p{PASSWORD} <<MYSQL_SCRIPT
    CREATE DATABASE {DATABASE NAME};
    MYSQL_SCRIPT

## 4. Verify Integration
Ensure that wordpress webiste is running without errors.

## Cleanup
To delete the resources and clean up your environment:
```hcl
terraform destroy --var-file=vars.tfvars
```