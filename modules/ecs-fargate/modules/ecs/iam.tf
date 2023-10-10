resource "aws_iam_role" "app_ecs_execution_role" {
  name = "app-ecs-task-execution-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }
}

# Attach the required permissions to the task execution role
resource "aws_iam_role_policy_attachment" "app_task_execution_policy_attachment" {
  role       = aws_iam_role.app_ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "secret_manager_policy_attachment" {
  role       = aws_iam_role.app_ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.app_ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "logs_policy_attachment" {
  role       = aws_iam_role.app_ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}