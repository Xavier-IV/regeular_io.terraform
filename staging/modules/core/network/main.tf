resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-vpc"
  }
}

resource "aws_security_group" "sg" {
  name   = "${var.global_app.name.kebab}-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 6379
    protocol    = "TCP"
    to_port     = 6379
    cidr_blocks = ["0.0.0.0/0"] # Redis private subnet only
    description = "REDIS"
  }

  ingress {
    from_port        = 80
    protocol         = "TCP"
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTP"
  }

  ingress {
    from_port        = 443
    protocol         = "TCP"
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "HTTPS"
  }

  ingress {
    from_port        = 3000
    protocol         = "TCP"
    to_port          = 3000
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "RAILS"
  }

  ingress {
    from_port        = 587
    protocol         = "TCP"
    to_port          = 587
    cidr_blocks      = ["10.0.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "SendGrid"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port        = 0
    protocol         = "TCP"
    to_port          = 65535
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "All outbound"
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-sg"
  }
}

resource "aws_security_group" "sg_vpn" {
  name   = "${var.global_app.name.kebab}-sg-vpn"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port        = 0
    protocol         = "TCP"
    to_port          = 65535
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "All inbound"
  }

  egress {
    from_port        = 0
    protocol         = "TCP"
    to_port          = 65535
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "All outbound"
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-sg-vpn"
  }
}