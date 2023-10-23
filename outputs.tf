# Output the VPC ID and Subnet IDs
output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id,
    aws_subnet.public_subnet_c.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_d.id,
    aws_subnet.private_subnet_e.id,
    aws_subnet.private_subnet_f.id
  ]
}

output "instance_id" {
  value = aws_instance.wpMaster_instance.id
}

# output "rds_endpoint" {
#   value = aws_db_instance.wordpress_rds.endpoint
# }

output "rds_endpoint" {
  value = split(":", aws_db_instance.wordpress_rds.endpoint)[0]
}

output "efs_dns_name" {
  value = aws_efs_file_system.wordpress_efs.dns_name
}

output "db_username" {
  value = var.db_username
}

output "db_password" {
  value = var.db_password
}
