resource "aws_efs_file_system" "wordpress_efs" {
  creation_token  = var.efs_name
  performance_mode = var.performance_mode
  throughput_mode = var.throughput_mode
  encrypted = true  # Enable encryption
  tags            = {
    Name = "wp-efs"
  }
}

resource "aws_efs_mount_target" "efs-mount-a" {
   file_system_id  = aws_efs_file_system.wordpress_efs.id
   subnet_id       = aws_subnet.public_subnet_a.id  
   security_groups = [aws_security_group.security_group_4.id] 
}

resource "aws_efs_mount_target" "efs-mount-b" {
   file_system_id  = aws_efs_file_system.wordpress_efs.id
   subnet_id       = aws_subnet.private_subnet_d.id 
   security_groups = [aws_security_group.security_group_4.id]  
}