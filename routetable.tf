# Use a data source to retrieve information about the existing Internet Gateway
data "aws_internet_gateway" "default" {
  tags = {
    Name = "igw-vpc"  # Replace with the actual name or tags of your Internet Gateway
  }
}

# Create Route Table 1
resource "aws_route_table" "route_table_1" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "wp-RT1"
  }
}

# Associate the route table with your public subnets
resource "aws_route_table_association" "route_table_1_association" {
  count         = 3
  subnet_id     = element(concat(aws_subnet.public_subnet_a[*].id, aws_subnet.public_subnet_b[*].id, aws_subnet.public_subnet_c[*].id), count.index)
  route_table_id = aws_route_table.route_table_1.id
}

# Attach the existing internet gateway to the route table
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.route_table_1.id
  destination_cidr_block = "0.0.0.0/0"  # This route sends all internet-bound traffic to the internet gateway
  gateway_id             = data.aws_internet_gateway.default.id  # Automatically uses the existing Internet Gateway
}

#=================================================================================================

# Create Route Table 2
resource "aws_route_table" "route_table_2" {
    vpc_id = data.aws_vpc.default.id


  tags = {
    Name = "wp-RT2"
  }
}

# Associate existing private subnets with Route Table 2
resource "aws_route_table_association" "route_table_2_association" {
  count         = 3
  subnet_id     = element(concat(aws_subnet.private_subnet_d[*].id, aws_subnet.private_subnet_e[*].id, aws_subnet.private_subnet_f[*].id), count.index)
  route_table_id = aws_route_table.route_table_2.id
}

  # Attach the existing internet gateway to the route table
resource "aws_route" "internet_gateway_route2" {
  route_table_id         = aws_route_table.route_table_2.id
  destination_cidr_block = "0.0.0.0/0"  # This route sends all internet-bound traffic to the internet gateway
  gateway_id             = data.aws_internet_gateway.default.id  # Automatically uses the existing Internet Gateway
}