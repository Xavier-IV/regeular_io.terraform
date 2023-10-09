output "repository_url" {
  value = data.aws_ecr_repository.app_ecr_repository.repository_url
}

output "image_tags" {
  value = data.aws_ecr_image.app_ecr_image.image_tags
}