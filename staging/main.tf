terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = var.aws.region
  access_key = var.aws.access_key
  secret_key = var.aws.secret_access_key
}

module "network" {
  source = "./modules/core/network"

  global_app = var.app
}

module "iam" {
  source     = "./modules/core/iam"
  global_app = var.app
}

module "secret_manager" {
  source     = "./modules/core/secret-manager"
  global_app = var.app
}

/* RDS */
module "rds" {
  count = var.app.with_database ? 1 : 0

  source = "./modules/core/rds"

  global_app            = var.app
  sg_id                 = module.network.sg_id
  secret_db_username    = module.secret_manager.secret_db_username
  secret_db_password    = module.secret_manager.secret_db_password
  private_subnet_az1_id = module.network.private_subnet_az1_id
  private_subnet_az2_id = module.network.private_subnet_az2_id
}

module "load-balancer" {
  source = "./modules/core/load-balancer"

  global_app     = var.app
  module-network = module.network
}

module "image" {
  source            = "./modules/core/image"
  docker_image_name = var.docker_image_name
}

module "elasticache" {
  count  = var.app.with_elasticache ? 1 : 0
  source = "./modules/core/elasticache"

  global_app     = var.app
  module-network = module.network

  depends_on = [module.network]
}

module "ecs-fargate" {
  source = "./modules/ecs-fargate"

  global_app        = var.app
  global_aws        = var.aws
  global_repository = var.repository

  module-image          = module.image
  module-secret-manager = module.secret_manager
  module-rds            = module.rds[0]
  module-load-balancer  = module.load-balancer
  module-network        = module.network

  docker_image_name = var.docker_image_name

  redis_url = "redis://${module.elasticache[0].hostname}:${module.elasticache[0].port}"

  depends_on = [
    module.network, module.rds, module.image, module.secret_manager, module.load-balancer, module.elasticache
  ]
}

provider "cloudflare" {
  api_token = var.cloudflare.api_token
}

data "cloudflare_zone" "app_cf_zone" {
  account_id = var.cloudflare.account_id
  name       = var.cloudflare.zone
}

resource "cloudflare_record" "app_cf_record_root" {
  zone_id = data.cloudflare_zone.app_cf_zone.zone_id
  name    = var.aws.route53.root
  value   = module.load-balancer.lb.dns_name

  proxied = true

  type = "CNAME"
  ttl  = 1
}

resource "cloudflare_record" "app_cf_record_root_business" {
  zone_id = data.cloudflare_zone.app_cf_zone.zone_id
  name    = var.aws.route53.root_business
  value   = module.load-balancer.lb.dns_name

  proxied = true

  type = "CNAME"
  ttl  = 1
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.app.name.standard}-bucket-${var.app.tag.environment}"
}

resource "aws_ses_email_identity" "verified_emails" {
  count = length(var.tester_emails)

  email = var.tester_emails[count.index]
}
