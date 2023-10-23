# Define Amazon ElastiCache Redis cluster

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id, aws_subnet.public_subnet_c.id]   # Use the public subnet IDs here
}

resource "aws_elasticache_cluster" "wordpress_redis" {
  cluster_id           = var.cluster_id
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  port                 = 6379

  parameter_group_name = "default.redis5.0"

  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

  security_group_ids   = [aws_security_group.security_group_6.id]

 # subnet_ids           = var.public_subnet_ids  # Use the public subnet IDs here

  tags = {
    Name = "wordpress-redis"
  }
}