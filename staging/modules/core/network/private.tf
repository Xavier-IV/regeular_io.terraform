resource "aws_subnet" "subnet_private_az1" {
  cidr_block           = "10.0.3.0/24"
  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = "apse1-az1"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-private-subnet-az1"
  }
}

resource "aws_route_table" "rt_private_az1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rt-az2"
  }
}

resource "aws_route_table_association" "rt_assoc_az1" {
  route_table_id = aws_route_table.rt_private_az1.id
  subnet_id      = aws_subnet.subnet_private_az1.id
}

resource "aws_subnet" "subnet_private_az2" {
  cidr_block           = "10.0.4.0/24"
  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = "apse1-az2"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-private-subnet-az2"
  }
}

resource "aws_route_table" "rt_private_az2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rt-az2"
  }
}

resource "aws_route_table_association" "rt_assoc_az2" {
  route_table_id = aws_route_table.rt_private_az2.id
  subnet_id      = aws_subnet.subnet_private_az2.id
}