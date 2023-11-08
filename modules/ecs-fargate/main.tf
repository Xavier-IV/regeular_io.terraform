module "image-ecs" {
  source = "./modules/ecs"

  global_app            = var.global_app
  module-image          = var.module-image
  module-secret-manager = var.module-secret-manager
  module-rds            = var.module-rds
  module-load-balancer  = var.module-load-balancer
  module-network        = var.module-network

  redis_url = var.redis_url

  depends_on = [var.module-rds]
}

module "pipeline-code-build" {
  source = "./modules/pipeline/code-build"

  global_app     = var.global_app
  global_aws = var.global_aws
  docker_image_name = var.docker_image_name
  module-network = var.module-network
  module-ecs     = module.image-ecs

  redis_url = var.redis_url
}

module "pipeline-code-deploy" {
  source = "./modules/pipeline/code-deploy"

  global_app = var.global_app

  ecs_cluster_name = module.image-ecs.ecs_cluster_name
  ecs_service_name = module.image-ecs.ecs_service_name

  lb_listener_arn = var.module-load-balancer.lb_listener_arn

  lb_target_group_blue_name  = var.module-load-balancer.lb_target_group_blue_name
  lb_target_group_green_name = var.module-load-balancer.lb_target_group_green_name
}

module "pipeline" {
  source = "./modules/pipeline"

  global_app = var.global_app
  global_repository = var.global_repository
}

module "waf" {
  count = var.global_app.with_waf ? 1 : 0
  source = "./modules/waf"

  module-load-balancer = var.module-load-balancer
  global_app           = var.global_app
}

module "route53" {
  source = "./modules/route53"
  app_lb = var.module-load-balancer.lb

  global_aws = var.global_aws
}