variable "secret_db_username" {
  type      = string
  sensitive = true
}

variable "secret_db_password" {
  type      = string
  sensitive = true
}

variable "sg_id" {}

variable "private_subnet_az1_id" {}
variable "private_subnet_az2_id" {}

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