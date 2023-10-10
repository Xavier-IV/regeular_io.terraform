variable "global_app" {
  type = object({
    domain = string,
    tag = object({
      name        = string,
      environment = string,
    }),
    name = object({
      standard = string,
      pascal   = string,
      kebab    = string
    }),
    with_database = bool
  })
}