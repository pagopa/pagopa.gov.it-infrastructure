terraform {
  required_version = ">= 1.0.0"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "PagoPa"

    workspaces {
      name = "pagopa-gov-it-shared"
    }
  }


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

/*
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
*/


resource "aws_iam_user" "circle_ci_user" {
  name = "circle-ci"

  tags = var.tags
}

resource "aws_iam_access_key" "circle_ci_access_key" {
  user = aws_iam_user.circle_ci_user.name
}

/*
The cloudfront:CreateInvalidation command does not support resource-level permissions. For this reason, only * is supported. Thus, it is not possible to restrict a user/role to only be able to invalidate a specific distribution.
Source: http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cf-api-permissions-ref.html
*/
resource "aws_iam_user_policy" "circle_ci_policy" {
  name = "circle-ci-policy-cdn"
  user = aws_iam_user.circle_ci_user.name

  policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "cloudfront:CreateInvalidation",
              "Effect": "Allow",
              "Resource": "*"
          }
      ]
    }
  EOT
}