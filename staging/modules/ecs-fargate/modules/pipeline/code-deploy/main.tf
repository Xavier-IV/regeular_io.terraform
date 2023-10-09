resource "aws_codedeploy_app" "code_deploy_app" {
  compute_platform = "ECS"
  name             = "${var.global_app.name.pascal}CodeDeployApp"
}

resource "aws_codedeploy_deployment_group" "code_deploy_group" {
  app_name               = aws_codedeploy_app.code_deploy_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.global_app.name.pascal}CodeDeploy-Group"
  service_role_arn       = aws_iam_role.code_deploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.lb_listener_arn]
      }

      target_group {
        name = var.lb_target_group_blue_name
      }

      target_group {
        name = var.lb_target_group_green_name
      }
    }
  }
}