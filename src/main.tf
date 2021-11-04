terraform {
  required_version = ">= 1.0.0"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "PagoPa"

    workspaces {
      name = "pagopa-gov-it"
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

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "static_bucket_certificate" {
  domain_name       = "test.pagopa.gov.it"
  validation_method = "DNS"

  subject_alternative_names = []

  tags = {
    terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "www_static_bucket_certificate" {
  domain_name       = "www.test.pagopa.gov.it"
  provider          = aws.us-east-1
  validation_method = "DNS"

  subject_alternative_names = []

  tags = {
    terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*



resource "aws_iam_user" "circle_ci_user" {
  name = "circle-ci"
}

resource "aws_iam_access_key" "circle_ci_access_key" {
  user = aws_iam_user.circle_ci_user.name
}

resource "aws_iam_user_policy" "circle_ci_policy" {
  name = "circle-ci-policy"
  user = aws_iam_user.circle_ci_user.name

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

*/