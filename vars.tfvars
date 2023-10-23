# Subnet variables
subnet_cidr_a   = "172.31.201.0/24"
subnet_cidr_b   = "172.31.202.0/24"
subnet_cidr_c   = "172.31.203.0/24"
subnet_cidr_d   = "172.31.204.0/24"
subnet_cidr_e   = "172.31.205.0/24"
subnet_cidr_f   = "172.31.206.0/24"

# Route table variables
route_table_name1 = "wp-public-RT"
route_table_name2 = "wp-private-RT"
internet_gateway_name = "wp-igw"

#ec2 instance
instance_name1 = "nat-instance"
instance_type1 = "t3a.small"
ami_id = "ami-0bb4c991fa89d4b9b"
instance_name2 = "master-instance"
instance_type2 = "t3a.small"

#rds
db_name = "wp-rds"
db_username = "admin"
db_password = "1234qwer"

#efs 
efs_name = "wp-efs"
performance_mode = "generalPurpose"
throughput_mode = "bursting"

#redis
cluster_id = "wordpress"
engine = "redis"
engine_version = "5.0.6"
subnet_group_name = "wp-redis-subnet"
node_type = "cache.t2.micro"