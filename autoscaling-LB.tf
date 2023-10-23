# Create an EC2 instance with IAM Role and Key Pair
resource "aws_instance" "wpMaster_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type1
  subnet_id     = aws_subnet.private_subnet_d.id
  security_groups = [aws_security_group.security_group_1.id]
  iam_instance_profile = "wp-instance-role"  # Assign the IAM role here = "wp-instance-role"  # Assign the IAM role here
  key_name     = aws_key_pair.wordpress_key.key_name  # Attach the existing key pair here

  user_data = templatefile("${path.module}/script/installation.sh", {
  dns_name = local.dns_name,
  rds_endpoint = local.rds_endpoint,
  db_username = var.db_username, 
  db_password = var.db_password,  
})

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "wordpress-autoscaled"
  }
}

# Create a Launch Configuration for the Auto Scaling Group
resource "aws_launch_configuration" "wordpress_launch_configuration" {
  name_prefix        = "wordpress-"
  image_id           = aws_instance.wpMaster_instance.ami
  instance_type      = var.instance_type1
  security_groups    = [aws_security_group.security_group_1.id]
  iam_instance_profile = "wp-instance-role"  # Assign the IAM role here
  
  user_data = templatefile("${path.module}/script/installation.sh", {
    dns_name      = local.dns_name,
    rds_endpoint  = local.rds_endpoint,
    db_username   = var.db_username,
    db_password   = var.db_password,
  })

  key_name = aws_key_pair.wordpress_key.key_name  # Attach the existing key pair here
}

resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "wordpress-asg"
  launch_configuration = aws_launch_configuration.wordpress_launch_configuration.name
  min_size             = 2     # Set the minimum size to 2
  max_size             = 4
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.private_subnet_d.id]

  # Attach an initial lifecycle hook
  lifecycle {
    create_before_destroy = true
  }
}

# Create a scaling policy based on CPU utilization
resource "aws_autoscaling_policy" "wordpress_cpu_scaling" {
  name                   = "wordpress-cpu-scaling"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 60

  # Configure the target tracking policy
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60    # Set your target CPU utilization threshold here
  }

  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

# Create a Load Balancer (ALB) and associate it with your ASG
resource "aws_lb" "wordpress_lb" {
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_subnet_e.id, aws_subnet.public_subnet_b.id]
}

resource "aws_lb_target_group" "wordpress_target_group" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
    type             = "forward"
  }
}

# Add Auto Scaling group instances to the target group
resource "aws_autoscaling_attachment" "wordpress_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn  = aws_lb_target_group.wordpress_target_group.arn
}