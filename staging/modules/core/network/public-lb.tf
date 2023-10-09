resource "aws_subnet" "subnet_public_az1" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone_id    = "apse1-az1"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-public-subnet-az1"
  }
}

resource "aws_route_table" "rt_pub_az1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rt-public-az1"
  }
}

resource "aws_route_table_association" "rt_assoc_pub_az1" {
  route_table_id = aws_route_table.rt_pub_az1.id
  subnet_id      = aws_subnet.subnet_public_az1.id
}

resource "aws_subnet" "subnet_public_az2" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone_id    = "apse1-az2"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-public-subnet-az2"
  }
}

resource "aws_route_table" "rt_pub_az2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rt-public-az2"
  }
}

resource "aws_route_table_association" "rt_assoc_pub_az2" {
  route_table_id = aws_route_table.rt_pub_az2.id
  subnet_id      = aws_subnet.subnet_public_az2.id
}