resource "aws_subnet" "subnet_client_vpn" {
  cidr_block              = "10.0.10.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone_id    = "apse1-az1"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-client-vpn-subnet"
  }
}

resource "aws_route_table" "rt_vpn" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rt-vpn"
  }
}

resource "aws_route_table_association" "rt_assoc_vpn" {
  route_table_id = aws_route_table.rt_vpn.id
  subnet_id      = aws_subnet.subnet_client_vpn.id
}