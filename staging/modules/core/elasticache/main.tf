resource "aws_cloudwatch_log_group" "ec_logs" {
  name = "aws-elasticache-logs-${var.global_app.name.kebab}"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_cloudwatch_log_group" "ec_engine_logs" {
  name = "aws-elasticache-engine-logs-${var.global_app.name.kebab}"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "${var.global_app.name.kebab}-ec-subnets"
  subnet_ids = [
    var.module-network.private_subnet_az1_id,
    var.module-network.private_subnet_az2_id
  ]

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id = "${var.global_app.name.kebab}-ec-cluster"

  engine_version = "7.0"
  port           = 6379

  engine = "redis"

  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  node_type            = "cache.t3.micro"

  apply_immediately = true

  subnet_group_name = aws_elasticache_subnet_group.redis_subnets.name

  security_group_ids = [var.module-network.sg_id]

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.ec_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.ec_engine_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

output "hostname" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes[0].address
}

output "port" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes[0].port
}