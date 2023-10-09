data "aws_ecr_repository" "app_ecr_repository" {
  name = var.docker_image_name
}

data "aws_ecr_image" "app_ecr_image" {
  repository_name = var.docker_image_name
  most_recent     = true
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  repository = data.aws_ecr_repository.app_ecr_repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 10 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}