terraform {
  required_version = ">= 1.1.5"

  backend "s3" {
    bucket         = "terraform-backend-3605"
    key            = "prod/devops/tfstate"
    region         = "eu-south-1"
    dynamodb_table = "terraform-lock"
  }

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "= 0.1.8"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63.0"
    }

  }
}

provider "aws" {
  region = var.region
}