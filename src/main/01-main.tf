terraform {
  required_version = ">= 1.0.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.75.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    bucket = "terraform-backend-3605"
    key    = "prod/shared/tfstate"
    region = "eu-south-1"
  }
}

resource "aws_acm_certificate" "static_bucket_certificate" {
  domain_name       = replace(var.domain_name, "-", ".")
  validation_method = "DNS"

  subject_alternative_names = []

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate" "www_static_bucket_certificate" {
  domain_name       = format("www.%s", replace(var.domain_name, "-", "."))
  provider          = aws.us-east-1
  validation_method = "DNS"

  subject_alternative_names = []

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# TODO remove this policy once migrated to github actions.

resource "aws_iam_user_policy" "circle_ci_policy" {
  name = format("circle-ci-policy-s3-%s", var.domain_name)
  user = data.terraform_remote_state.shared.outputs.circle_ci_user_name

  policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "s3:*",
              "Resource": [
                  "arn:aws:s3:::${var.domain_name}",
                  "arn:aws:s3:::${var.domain_name}/*"
              ]
          }      
      ]
    }
  EOT
}

resource "aws_iam_policy" "githubdeploys3" {
  name        = "GitHubDeployS3"
  description = "Purge Cloud Front cache."

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = "s3:*",
          Resource = [
            "arn:aws:s3:::${var.domain_name}",
            "arn:aws:s3:::${var.domain_name}/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "github_deploy_s3" {
  role       = data.terraform_remote_state.shared.outputs.iam_role_deploy_name
  policy_arn = aws_iam_policy.githubdeploys3.arn
}