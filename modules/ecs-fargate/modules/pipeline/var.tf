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

variable "global_repository" {
  type = object({
    name = string,
    type = string,
    branch = string,
  })
}
