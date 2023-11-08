variable "module-image" {}
variable "module-secret-manager" {}
variable "module-rds" {}
variable "module-load-balancer" {}
variable "module-network" {}

variable "redis_url" {
  type = string
}

variable "global_app" {
  type = object({
    domain = string,
    tag    = object({
      name        = string,
      environment = string,
    }),
    name = object({
      pascal = string,
      kebab  = string
    }),
    with_waf = bool
  })
}

variable "global_aws" {
  type = object({
    account_id        = string,
    region            = string,
    access_key        = string,
    secret_access_key = string,

    route53 = object({
      root          = string,
      root_business = string,
      zone          = string,
      root_admin    = string,
      zone_admin = string
    }),
  })
  sensitive = true
}

variable "global_repository" {
  type = object({
    name   = string,
    type   = string,
    branch = string,
  })
}

variable "docker_image_name" {
  type = string
}