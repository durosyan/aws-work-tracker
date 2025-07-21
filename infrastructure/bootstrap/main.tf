provider "aws" {
  region = var.aws_region
}

# Backend configuration for Terraform state management

resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "terraform-state"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Role for GitHub Actions to deploy the main stuff, needs to be least privileged
# TODO: figure out what permissions are actually needed for the deployment

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # thumbprint_list = [var.thumbprint]
}

resource "aws_iam_role" "github_actions" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.repo_owner}/${var.repo_name}:ref:refs/heads/${var.branch}"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.github_actions.id
  policy = file("${path.module}/github_actions_ci_policy.json")
}