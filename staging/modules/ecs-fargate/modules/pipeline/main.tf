resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "${var.global_app.name.kebab}-codepipeline-cache"

  force_destroy = true

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-pipeline-bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "pipeline_bucket_lc" {
  bucket = aws_s3_bucket.pipeline_bucket.id
  rule {
    status = "Enabled"
    id     = "expire_all_files"
    expiration {
      days = 1
    }
  }
}

resource "aws_codestarconnections_connection" "codestar" {
  name          = "${var.global_repository.type}${var.global_app.name.pascal}"
  provider_type = "${var.global_repository.type}"

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-codestar-connect"
  }
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.global_app.name.kebab}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
    Name        = "${var.global_app.tag.name}-pipeline"
  }

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      run_order        = 1
      category         = "Source"
      name             = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestar.arn
        FullRepositoryId = "${var.global_repository.name}"
        BranchName       = "${var.global_repository.branch}"
      }
    }
  }

  stage {
    name = "Build"
    action {
      run_order        = 2
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "${var.global_app.name.pascal}CodebuildProject"
      }
    }
  }

  # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-ECSbluegreen.html
  stage {
    name = "Deploy"

    action {
      run_order       = 3
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ApplicationName                = "${var.global_app.name.pascal}CodeDeployApp"
        DeploymentGroupName            = "${var.global_app.name.pascal}CodeDeploy-Group"
        TaskDefinitionTemplateArtifact = "BuildArtifact"
        AppSpecTemplateArtifact        = "BuildArtifact"
        Image1ArtifactName             = "BuildArtifact"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }
}