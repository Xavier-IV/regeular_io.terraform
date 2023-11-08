data "aws_route53_zone" "r53_zone" {
  name = var.global_aws.route53.zone
}

resource "aws_route53_record" "root_1_domain" {
  name    = ""
  type    = "A"
  zone_id = data.aws_route53_zone.r53_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = "dualstack.${var.app_lb.dns_name}"
    zone_id                = var.app_lb.zone_id
  }
}

resource "aws_route53_record" "root_2_domain" {
  name    = var.global_aws.route53.root
  type    = "A"
  zone_id = data.aws_route53_zone.r53_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = "dualstack.${var.app_lb.dns_name}"
    zone_id                = var.app_lb.zone_id
  }
}

resource "aws_route53_record" "root_business_domain" {
  name    = var.global_aws.route53.root_business
  type    = "A"
  zone_id = data.aws_route53_zone.r53_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = "dualstack.${var.app_lb.dns_name}"
    zone_id                = var.app_lb.zone_id
  }
}

data "aws_route53_zone" "r53_zone_net" {
  name = var.global_aws.route53.zone_admin
}

resource "aws_route53_record" "root_admin_domain" {
  name    = var.global_aws.route53.root_admin
  type    = "A"
  zone_id = data.aws_route53_zone.r53_zone_net.zone_id

  alias {
    evaluate_target_health = false
    name                   = "dualstack.${var.app_lb.dns_name}"
    zone_id                = var.app_lb.zone_id
  }
}