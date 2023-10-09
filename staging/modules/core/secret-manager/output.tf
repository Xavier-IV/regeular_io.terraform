output "secret_rails_master_key_arn" {
  value     = data.aws_secretsmanager_secret_version.rails_master_key_version.arn
  sensitive = true
}

output "secret_db_username_arn" {
  value     = data.aws_secretsmanager_secret_version.secret_db_username_version.arn
  sensitive = true
}

output "secret_db_password_arn" {
  value     = data.aws_secretsmanager_secret_version.secret_db_password_version.arn
  sensitive = true
}

output "secret_db_username" {
  value     = data.aws_secretsmanager_secret_version.secret_db_username_version.secret_string
  sensitive = true
}

output "secret_db_password" {
  value     = data.aws_secretsmanager_secret_version.secret_db_password_version.secret_string
  sensitive = true
}