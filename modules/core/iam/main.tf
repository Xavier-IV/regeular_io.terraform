resource "aws_iam_role" "ec2_role" {
  name = "${var.global_app.name.kebab}-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_iam_policy" "policy" {
  name = "${var.global_app.name.kebab}-policy"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:Describe*",
          "ssm:Get*",
          "ssm:List*"
        ],
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ecs" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.global_app.name.kebab}-terraform-profile"
  role = aws_iam_role.ec2_role.name
}
