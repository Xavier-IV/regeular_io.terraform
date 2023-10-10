data "aws_secretsmanager_secret" "rails_master_key" {
  name = "/${var.global_app.tag.environment}/secret/rails_master_key"
}

data "aws_secretsmanager_secret_version" "rails_master_key_version" {
  secret_id = data.aws_secretsmanager_secret.rails_master_key.id
}

data "aws_secretsmanager_secret" "secret_db_username" {
  name = "/${var.global_app.tag.environment}/secret/db/username"
}

data "aws_secretsmanager_secret_version" "secret_db_username_version" {
  secret_id = data.aws_secretsmanager_secret.secret_db_username.id
}

data "aws_secretsmanager_secret" "secret_db_password" {
  name = "/${var.global_app.tag.environment}/secret/db/password"
}

data "aws_secretsmanager_secret_version" "secret_db_password_version" {
  secret_id = data.aws_secretsmanager_secret.secret_db_password.id
}