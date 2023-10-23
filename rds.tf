resource "aws_db_instance" "wordpress_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = var.db_name
  username             = var.db_username
  password             = var.db_password
  multi_az             = false
  skip_final_snapshot  = true  # Set skip_final_snapshot to true to skip taking a final snapshot

  tags = {
    Name = "WP-RDS"
  }
}