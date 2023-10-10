resource "aws_db_subnet_group" "app_db_subnets" {
  name       = "${var.global_app.name.kebab}-public-subnets"
  subnet_ids = [var.private_subnet_az1_id, var.private_subnet_az2_id]

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rds-subnets"
  }
}

# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
resource "aws_db_instance" "app_db" {
  engine = "postgres"

  # $ aws rds describe-db-engine-versions --engine <mysql|postgres>
  engine_version         = "15.4"
  parameter_group_name   = "default.postgres15"
  identifier             = var.global_app.name.kebab
  allocated_storage      = 20
  instance_class         = "db.t3.micro"
  username               = var.secret_db_username
  password               = var.secret_db_password
  db_subnet_group_name   = aws_db_subnet_group.app_db_subnets.name
  vpc_security_group_ids = [var.sg_id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-rds"
  }
}