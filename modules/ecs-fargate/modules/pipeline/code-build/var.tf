variable "module-network" {}

variable "module-ecs" {}

variable "redis_url" {
  type = string
}

variable "global_aws" {
  type = object({
    account_id        = string,
    region            = string,
    access_key        = string,
    secret_access_key = string,

    route53 = object({
      root = string,
      zone = string
    }),
  })

  sensitive = true
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
    })
  })
}

variable "docker_image_name" {
  type = string
}