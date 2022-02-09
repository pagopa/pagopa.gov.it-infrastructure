terraform {
  required_version = ">= 1.1.5"
  # TODO should it be AWS or Azure?
  /*
  backend "azurerm" {
    resource_group_name  = "io-infra-rg"
    storage_account_name = "ioinfrastterraform"
    container_name       = "azuredevopsstate"
    key                  = "cstar-iac-projects.terraform.tfstate"
  }
  */
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