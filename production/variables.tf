variable "aws" {
  type = object({
    account_id        = string,
    region            = string,
    access_key        = string,
    secret_access_key = string,

    route53 = object({
      root          = string,
      root_business = string,
      zone          = string
    }),
  })
  default = {
    account_id        = "",
    region            = "ap-southeast-1",
    access_key        = "",
    secret_access_key = "",
    route53 = {
      root          = "staging",
      root_business = "staging-business",
      zone          = "navly.app"
    }
  }
  sensitive = true
}

/*
 * App related
 */

variable "app" {
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
    with_database    = bool
    with_elasticache = bool
  })
  default = {
    domain = "staging",
    tag = {
      name        = "staging",
      environment = "staging"
    }
    name = {
      standard = "navly"
      pascal   = "StaginNavly",
      kebab    = "staging-navly-app"
    }
    with_database    = true
    with_elasticache = true
  }
}

variable "repository" {
  type = object({
    name   = string,
    type   = string,
    branch = string,
  })
}

variable "cloudflare" {
  type = object({
    api_token  = string,
    account_id = string,
    zone       = string
  })

  sensitive = true
}

/**
 * DOCKER
 */
variable "docker_image_name" {
  type    = string
  default = "navly"
}

/*
 * Secrets
 */

variable "secret_db_username" {
  type      = string
  sensitive = true
}

variable "secret_db_password" {
  type      = string
  sensitive = true
}

variable "tester_emails" {
  type    = list(string)
  default = []
}
