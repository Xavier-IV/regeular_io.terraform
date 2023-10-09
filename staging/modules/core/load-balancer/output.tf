output "lb_target_group_1_arn" {
  value = aws_lb_target_group.app_lb_target_group_1.arn
}

output "lb_target_group_2_arn" {
  value = aws_lb_target_group.app_lb_target_group_2.arn
}

output "lb" {
  value = aws_lb.app_load_balancer
}

output "lb_arn" {
  value = aws_lb.app_load_balancer.arn
}

output "lb_listener_arn" {
  value = aws_lb_listener.app_lb_listener.arn
}

output "lb_target_group_blue_name" {
  value = aws_lb_target_group.app_lb_target_group_1.name
}

output "lb_target_group_green_name" {
  value = aws_lb_target_group.app_lb_target_group_2.name
}