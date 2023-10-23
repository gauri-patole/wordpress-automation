variable "subnet_cidr_a" {
  description = "CIDR block for Subnet A"
  type        = string
}

variable "subnet_cidr_b" {
  description = "CIDR block for Subnet B"
  type        = string
}

variable "subnet_cidr_c" {
  description = "CIDR block for Subnet C"
  type        = string
}

variable "subnet_cidr_d" {
  description = "CIDR block for Subnet D"
  type        = string
}

variable "subnet_cidr_e" {
  description = "CIDR block for Subnet E"
  type        = string
}

variable "subnet_cidr_f" {
  description = "CIDR block for Subnet F"
  type        = string
}

variable "route_table_name1" {
  description = "Identifier for Public Route table."
  type        = string
}

variable "route_table_name2" {
  description = "Identifier for Private Route table."
  type        = string
}

variable "internet_gateway_name" {
  description = "Identifier for the internet gateway."
  type        = string
}

variable "instance_name1" {
  description = "Identifier for the NAT instance."
  type        = string
}

variable "instance_type1" {
  description = "Instance type for NAT instance."
  type        = string
}

variable "ami_id" {
  description = ""
  type        = string
}

variable "instance_name2" {
  description = "Identifier for the Master instance."
  type        = string
}

variable "instance_type2" {
  description = "Instance type for Master instance."
  type        = string
}

variable "db_name" {
  description = "An identifier for the database that will be created in RDS."
  type        = string
}

variable "db_username" {
  description = "Login credentials - username for the database."
  type        = string
}

variable "db_password" {
  description = "Login credentials - password for the database."
  type        = string
}

 variable "efs_name" {
  description = "Identifier for the file system in EFS."
  type    = string
 }

variable "cluster_id" {
  description = "The ID of the cluster"
  type        = string
  default     = "wordpress"
}

variable "performance_mode" {
  description = "Choose performance mode according to the requirement. Here, general purpose is preferred."
  type        = string
}

variable "throughput_mode" {
  description = "Choose throughput mode according to the requirement. Here, bursting is preferred."
  type        = string
}

variable "engine" {
  description = "Choose an engine for elasticache according to the requirement. Here, mysql is preffered."
  type        = string
}

variable "engine_version" {
  description = "Choose an engine version for elasticache according to the requirement."
  type        = string
}

variable "node_type" {
  description = "Select a node type for the elasticache server."
  type        = string
}

variable "subnet_group_name" {
  description = "An identifier for the subnet group pertaining to the redis server."
  type        = string
}