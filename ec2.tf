# Instance1
locals {
  rds_endpoint = aws_db_instance.wordpress_rds.endpoint
  dns_name     = aws_efs_file_system.wordpress_efs.dns_name
}

resource "aws_instance" "Nat_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type1
  subnet_id     = aws_subnet.public_subnet_a.id
  key_name      = aws_key_pair.wordpress_key.key_name
  iam_instance_profile = "wp-instance-role"  # Assign the IAM role here

  tags = {
    Name = "Nat_instance"
  }
}

resource "aws_eip" "one_eip" {
  instance = aws_instance.Nat_instance.id
}

# Generate a new SSH key pair
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Extract the public key from the private key
data "tls_public_key" "my_key" {
  private_key_pem = tls_private_key.my_key.private_key_pem
}

# Create an AWS key pair using the generated public key
resource "aws_key_pair" "wordpress_key" {
  key_name   = "wordpress-key"  # Change this to your desired key pair name
  public_key = data.tls_public_key.my_key.public_key_openssh
}

# Instance 2
resource "aws_instance" "Master_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type2
  subnet_id       = aws_subnet.private_subnet_d.id
  security_groups = [aws_security_group.security_group_1.id]  # Wrap it in a list

  key_name     = aws_key_pair.wordpress_key.key_name  # Associate the SSH key pair with the instance
  iam_instance_profile = "wp-instance-role"  # Assign the IAM role here

  tags = {
    Name = "Master_instance"
  }

  user_data = templatefile("${path.module}/script/installation.sh", {
  dns_name = local.dns_name,
  rds_endpoint = local.rds_endpoint,
  db_username = var.db_username, 
  db_password = var.db_password,  
})

  associate_public_ip_address = true  # Associates an Elastic IP with this instance

  depends_on = [
    aws_efs_file_system.wordpress_efs,
    aws_db_instance.wordpress_rds
  ]
}