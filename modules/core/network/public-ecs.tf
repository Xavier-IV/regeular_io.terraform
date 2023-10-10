/* Internet Gateway */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-igw"
  }
}

resource "aws_subnet" "subnet_ecs_az1" {
  cidr_block              = "10.0.11.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone_id    = "apse1-az1"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-ecs-subnet"
  }
}

resource "aws_route_table" "rt_ecs_az1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rt-ecs-az1"
  }
}

resource "aws_route_table_association" "rt_assoc_ecs" {
  route_table_id = aws_route_table.rt_ecs_az1.id
  subnet_id      = aws_subnet.subnet_ecs_az1.id
}