resource "aws_cloudwatch_log_group" "capstone-group" {
  name = "capstone-group"

  tags = {
    Environment = "blackbelt-capstone"
  }
}

resource "aws_codebuild_project" "blackbelt-capstone-tf" {
  name          = "blackbelt-capstone-tf"
  description   = "blackbelt capstone infra builder"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_tf.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "capstone-group"
      stream_name = "terraform-build"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/ssadowski-uturn/blackbelt-tf-aws.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  tags = {
    Environment = "blacbelt-capstone"
  }

  depends_on = [aws_cloudwatch_log_group.capstone-group]
}

resource "aws_codebuild_project" "blackbelt-capstone-api" {
  name          = "blackbelt-capstone-api"
  description   = "blackbelt capstone api builder"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_tf.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0" #this needs to be changed
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "capstone-group"
      stream_name = "api-build"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/ssadowski-uturn/blackbelt-api-registration.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  tags = {
    Environment = "blacbelt-capstone"
  }

  depends_on = [aws_cloudwatch_log_group.capstone-group]
}