#resource "aws_appautoscaling_target" "ecs_target" {
#  max_capacity       = 2
#  min_capacity       = 1
#  resource_id        = "service/${aws_ecs_cluster.app_ecs_cluster.name}/app-task-family"
#  scalable_dimension = "ecs:service:DesiredCount"
#  service_namespace  = "ecs"
#
#  tags = {
#    Environment = var.global_app.tag.environment
#    Application = var.global_app.tag.name
#  }
#}
#
#resource "aws_appautoscaling_policy" "ecs_policy" {
#  name               = "${var.global_app.name.kebab}-ecs-autoscaling-policy"
#  policy_type        = "StepScaling"
#  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
#
#  step_scaling_policy_configuration {
#    adjustment_type         = "ChangeInCapacity"
#    cooldown                = 60
#    metric_aggregation_type = "Average"
#
#    step_adjustment {
#      scaling_adjustment          = 1
#      metric_interval_upper_bound = 1000
#    }
#
#    step_adjustment {
#      scaling_adjustment          = 2
#      metric_interval_lower_bound = 1000
#    }
#  }
#}
#
#resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm" {
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = "2"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/ECS"
#  period              = "60"
#  statistic           = "Average"
#  threshold           = "80"
#  alarm_description   = "Alarm when CPU utilization exceeds 80%"
#  alarm_name          = "${var.global_app.name.kebab}-ecs-cpu-alarm"
#  alarm_actions       = [aws_appautoscaling_policy.ecs_policy.arn]
#  dimensions          = {
#    ClusterName = aws_ecs_cluster.app_ecs_cluster.name
#    ServiceName = "app-task-family"
#  }
#
#  tags = {
#    Environment = var.global_app.tag.environment
#    Application = var.global_app.tag.name
#  }
#}