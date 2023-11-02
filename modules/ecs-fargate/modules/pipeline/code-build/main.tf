resource "aws_codebuild_project" "codebuild_project" {
  name          = "${var.global_app.name.pascal}CodebuildProject"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "RAILS_SERVE_STATIC_FILES"
      value = "true"
    }

    environment_variable {
      name  = "REDIS_URL"
      value = var.redis_url
    }

    environment_variable {
      name  = "RAILS_ENV"
      value = var.global_app.tag.environment
    }

    environment_variable {
      name  = "TASK_DEFINITION_NAME"
      value = var.module-ecs.ecs_service_name
    }

    environment_variable {
      name  = "REPOSITORY_URI"
      value = "${var.global_aws.account_id}.dkr.ecr.${var.global_aws.region}.amazonaws.com/${var.docker_image_name}"
    }

    environment_variable {
      name  = "REPOSITORY_NAME"
      value = "${var.docker_image_name}"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "${var.global_aws.account_id}"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "firelens-container"
      stream_name = "codebuild"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yaml"
  }

  source_version = "master"

  #  vpc_config {
  #    vpc_id = var.module-network.vpc_id
  #
  #    subnets = [
  #      var.module-network.private_subnet_with_nat_id
  #    ]
  #
  #    security_group_ids = [
  #      var.module-network.sg_id
  #    ]
  #  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-codebuild"
  }
}