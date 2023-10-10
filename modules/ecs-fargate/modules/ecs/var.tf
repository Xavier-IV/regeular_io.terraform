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
    })
  })
}