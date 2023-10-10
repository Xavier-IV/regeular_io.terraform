resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "app-ecs-cluster"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

# Define a task definition for your ECS service
resource "aws_ecs_task_definition" "app_task_definition" {
  family                = "app-task-family"
  container_definitions = jsonencode([
    {
      name        = "app-task-family",
      image       = "${var.module-image.repository_url}:${var.module-image.image_tags[0]}",
      essential   = true,
      environment = [
        {
          name  = "RAILS_ENV",
          value = "staging"
        },
        {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "true"
        },
        {
          name  = "REGEULAR_DATABASE_HOST"
          value = var.module-rds.db_address
        },
        {
          name  = "RAILS_LOG_TO_STDOUT",
          value = "true"
        },
        {
          name  = "REGEULAR_DOMAIN"
          value = var.global_app.domain
        }
      ],
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp"
        }
      ],
      secrets = [
        {
          name      = "RAILS_MASTER_KEY"
          valueFrom = var.module-secret-manager.secret_rails_master_key_arn
        },
        {
          name      = "REGEULAR_DATABASE_USERNAME",
          valueFrom = var.module-secret-manager.secret_db_username_arn
        },
        {
          name      = "REGEULAR_DATABASE_PASSWORD",
          valueFrom = var.module-secret-manager.secret_db_password_arn
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          awslogs-group         = "firelens-container",
          awslogs-region        = "ap-southeast-1",
          awslogs-create-group  = "true",
          awslogs-stream-prefix = "firelens"
        }
      }
    }
  ])

  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.app_ecs_execution_role.arn

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_ecs_service" "app_ecs_service" {
  name            = aws_ecs_task_definition.app_task_definition.family
  cluster         = aws_ecs_cluster.app_ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  health_check_grace_period_seconds = 300

  network_configuration {
    security_groups  = [var.module-network.sg_id]
    subnets          = [var.module-network.public_subnet_ecs_az1_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.module-load-balancer.lb_target_group_1_arn
    container_name   = aws_ecs_task_definition.app_task_definition.family
    container_port   = 3000
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # Ignore changes in load balancer when pipeline has already triggered.
  #
  # If we push code, pipeline will trigger, causing a drift in ECS
  # mapping to load balancer. When you run a new terraform apply, it will
  # detect the drift causing more issues.
  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.app_task_execution_policy_attachment]

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}