# Use the default VPC and its public subnets
data "aws_vpc" "default" {
  default = true
}

# Define public subnets using explicitly specified CIDR blocks
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.subnet_cidr_a
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name       = "wp-public-us-east-1a"
    Visibility = "public"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.subnet_cidr_b
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name       = "wp-public-us-east-1b"
    Visibility = "public"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.subnet_cidr_c
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name       = "wp-public-us-east-1c"
    Visibility = "public"
  }
}

# Define private subnets in different availability zones
resource "aws_subnet" "private_subnet_d" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.subnet_cidr_d
  availability_zone       = "us-east-1d"

  tags = {
    Name       = "wp-private-us-east-1d"
    Visibility = "private"
  }
}

resource "aws_subnet" "private_subnet_e" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.subnet_cidr_e
  availability_zone       = "us-east-1e"

  tags = {
    Name       = "wp-private-us-east-1e"
    Visibility = "private"
  }
}

resource "aws_subnet" "private_subnet_f" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.subnet_cidr_f
  availability_zone       = "us-east-1f"

  tags = {
    Name       = "wp-private-us-east-1f"
    Visibility = "private"
  }
}