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
variable "ecs_cluster_name" {}

variable "ecs_service_name" {}

variable "lb_listener_arn" {}

variable "lb_target_group_blue_name" {}
variable "lb_target_group_green_name" {}