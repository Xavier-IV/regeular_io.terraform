variable "app_lb" {}

variable "global_aws" {
  type = object({
    route53 = object({
      root          = string,
      root_business = string,
      zone          = string
    }),
  })
}