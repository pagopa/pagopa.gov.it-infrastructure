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