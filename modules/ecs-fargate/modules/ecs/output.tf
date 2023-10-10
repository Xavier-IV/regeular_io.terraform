output "ecs_cluster_name" {
  value = aws_ecs_cluster.app_ecs_cluster.name
}
output "ecs_service_name" {
  value = aws_ecs_service.app_ecs_service.name
}