terraform {
  required_version = ">= 1.0.0"

  backend "s3" {}


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# Budget alert

data "aws_secretsmanager_secret" "slack_io_status" {
  name = "slack/io-status"
}

data "aws_secretsmanager_secret_version" "slack_io_status_lt" {
  secret_id = data.aws_secretsmanager_secret.slack_io_status.id
}

module "budget_alert" {
  source                         = "hazelops/budget-alert/aws"
  aws_account_id                 = data.aws_caller_identity.current.account_id
  env                            = var.tags["Environment"]
  limit_amount                   = "200"
  subscription_endpoint_protocol = "email"
  subscription_endpoint          = jsondecode(data.aws_secretsmanager_secret_version.slack_io_status_lt.secret_string)["email"]
  time_period_start              = "2021-11-01_00:00"
  time_period_end                = "2087-01-01_00:00"
  currency                       = "USD" # EUR is not supported :(
}

# github openid identity provider.
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

resource "aws_iam_role" "githubdeploy" {
  name        = "GitHubActionDeploy"
  description = "Role to assume to deploy the static website"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_website_repository}:*"
          },
          "ForAllValues:StringEquals" = {
            "token.actions.githubusercontent.com:iss" : "https://token.actions.githubusercontent.com",
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cleancdncache" {
  name        = "CloudFrontCachePurge"
  description = "Purge Cloud Front cache."

  policy = jsonencode({

    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action"   = "cloudfront:CreateInvalidation",
        "Effect"   = "Allow",
        "Resource" = "*"
      }
    ]

  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.githubdeploy.name
  policy_arn = aws_iam_policy.cleancdncache.arn
}

resource "aws_iam_role" "githubiac" {
  name        = "GitHubActionIAC"
  description = "Role to assume to deploy the static website"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_infra_repository}:*"
          },
          "ForAllValues:StringEquals" = {
            "token.actions.githubusercontent.com:iss" : "https://token.actions.githubusercontent.com",
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}


resource "aws_iam_role_policy_attachment" "githubiac" {
  role       = aws_iam_role.githubiac.name
  policy_arn = data.aws_iam_policy.admin_access.arn
}