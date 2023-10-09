resource "aws_lb" "app_load_balancer" {
  name               = "${var.global_app.name.kebab}-lb"
  load_balancer_type = "application"

  # Set to true if you're launching behind VPN
  internal = false

  subnets = [
    var.module-network.public_subnet_az1_id,
    var.module-network.public_subnet_az2_id
  ]

  security_groups = [var.module-network.sg_id]

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_lb_target_group" "app_lb_target_group_1" {
  name        = "${var.global_app.name.kebab}-lb-tg-1"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.module-network.vpc_id

  health_check {
    matcher = "200,301,302"
    path    = "/health"
    port    = 3000
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_lb_target_group" "app_lb_target_group_2" {
  name        = "${var.global_app.name.kebab}-lb-tg-2"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.module-network.vpc_id

  health_check {
    matcher = "200,301,302"
    path    = "/health"
    port    = 3000
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_load_balancer.arn # Referencing our load balancer
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.acm_cert.arn

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }

  lifecycle {
    ignore_changes = [default_action]
  }

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.app_lb_target_group_1.arn
        weight = 100
      }

      target_group {
        arn    = aws_lb_target_group.app_lb_target_group_2.arn
        weight = 0
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.global_app.domain

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}
