# Define Security Group 1 = PUBLIC SECURITY GROUP
resource "aws_security_group" "security_group_1" {
  name               = "wp-public-sg"
  description        = "Public Security Group."
  vpc_id             = data.aws_vpc.default.id
}

# Define inbound rules for IPv4
resource "aws_security_group_rule" "sg1_inbound_ipv4_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_1.id
}

resource "aws_security_group_rule" "sg1_inbound_ipv4_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_1.id
}

resource "aws_security_group_rule" "sg1_inbound_ipv4_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_1.id
}

# Define inbound rules for IPv6
resource "aws_security_group_rule" "sg1_inbound_ipv6_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.security_group_1.id
}

resource "aws_security_group_rule" "sg1_inbound_ipv6_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.security_group_1.id
}

resource "aws_security_group_rule" "sg1_inbound_ipv6_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.security_group_1.id
}

# Allow all outbound traffic for both IPv4 and IPv6
resource "aws_security_group_rule" "outbound_ipv4" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_1.id
}

resource "aws_security_group_rule" "outbound_ipv6" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.security_group_1.id
}

#=========================================================================================

# Define Security Group 2 = PRIVATE SECURITY GROUP

resource "aws_security_group" "security_group_2" {
  name        = "wp-private-sg"
  description = "Private Security Group."
  vpc_id             = data.aws_vpc.default.id

}

# Define inbound rules for HTTP, HTTPS, and SSH
resource "aws_security_group_rule" "sg2_inbound_http" {
  type               = "ingress"
  from_port          = 80
  to_port            = 80
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.security_group_2.id
}

resource "aws_security_group_rule" "sg2_inbound_https" {
  type               = "ingress"
  from_port          = 443
  to_port            = 443
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.security_group_2.id
}

resource "aws_security_group_rule" "sg2_inbound_ssh" {
  type               = "ingress"
  from_port          = 22
  to_port            = 22
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.security_group_2.id
}

# Define outbound rules for all traffic
resource "aws_security_group_rule" "sg2_outbound" {
  type               = "egress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.security_group_2.id
}

#================================================================================

# Define Security Group 3 = LOADBALANCER SECURITY GROUP
resource "aws_security_group" "security_group_3" {
  name        = "wp-loadbalancer-sg"
  description = "Security Group for load balancer."
  vpc_id      = data.aws_vpc.default.id

}

# Define inbound rules for HTTP and HTTPS for IPv4 and IPv6
resource "aws_security_group_rule" "sg3_inbound_http" {
  type               = "ingress"
  from_port          = 80
  to_port            = 80
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.security_group_3.id
}

resource "aws_security_group_rule" "sg3_inbound_https" {
  type               = "ingress"
  from_port          = 443
  to_port            = 443
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.security_group_3.id
}

# Define outbound rules for all traffic for both IPv4 and IPv6
resource "aws_security_group_rule" "sg3_outbound_ipv4" {
  type               = "egress"
  from_port          = 0
  to_port            = 65535
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.security_group_3.id
}

resource "aws_security_group_rule" "sg3_outbound_ipv6" {
  type               = "egress"
  from_port          = 0
  to_port            = 65535
  protocol           = "tcp"
  ipv6_cidr_blocks   = ["::/0"]
  security_group_id  = aws_security_group.security_group_3.id
}

#================================================================================

# Define Security Group 4 = EFS

resource "aws_security_group" "security_group_4" {
  name        = "wp-efs-sg"
  description = "Security Group for elastic file storage."
  vpc_id      = data.aws_vpc.default.id

}

# Define a rule for NFS (Port 2049) for inbound traffic from public_security_group and private_security_group
resource "aws_security_group_rule" "nfs_inbound_rule" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.security_group_1.id
  security_group_id        = aws_security_group.security_group_4.id
}

resource "aws_security_group_rule" "nfs_inbound_rule_private" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.security_group_2.id
  security_group_id        = aws_security_group.security_group_4.id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "outbound_rule" {
  type               = "egress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"  # All protocols
  cidr_blocks        = ["0.0.0.0/0"]  # Allow all outbound traffic
  security_group_id  = aws_security_group.security_group_4.id
}

#================================================================================

# Define Security Group 5 = RDS SECURITY GROUP

resource "aws_security_group" "security_group_5" {
  name        = "wp-rds-sg"
  description = "Security Group for RDS"
  vpc_id      = data.aws_vpc.default.id

}

# Define an inbound rule for MySQL/Aurora at port 3306 from security_group_1 and security_group_2
resource "aws_security_group_rule" "sg5_inbound_mysql_aurora" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security_group_5.id
  source_security_group_id = aws_security_group.security_group_1.id
}

resource "aws_security_group_rule" "sg5_inbound_mysql_aurora_private" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security_group_5.id
  source_security_group_id = aws_security_group.security_group_2.id
}

# Allow all outbound traffic to 0.0.0.0/0
resource "aws_security_group_rule" "sg5_outbound_rule" {
  type               = "egress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"  # All protocols
  cidr_blocks        = ["0.0.0.0/0"]  # Allow all outbound traffic
  security_group_id  = aws_security_group.security_group_5.id
}

#================================================================================

# Define Security Group 6 = Redis Server

resource "aws_security_group" "security_group_6" {
  name        = "wp-redis-sg"
  description = "Security Group for Redis Server"
  vpc_id    = data.aws_vpc.default.id

}

# Define an inbound rule for custom TCP at port 6379 from security_group_1 and security_group_2
resource "aws_security_group_rule" "redis_inbound_rule_sg1" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security_group_6.id
  source_security_group_id = aws_security_group.security_group_1.id
}

resource "aws_security_group_rule" "redis_inbound_rule_sg2" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.security_group_6.id
  source_security_group_id = aws_security_group.security_group_2.id
}

# Allow all outbound traffic to 0.0.0.0/0
resource "aws_security_group_rule" "redis_outbound_rule" {
  type               = "egress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"  # All protocols
  cidr_blocks        = ["0.0.0.0/0"]  # Allow all outbound traffic
  security_group_id  = aws_security_group.security_group_6.id
}