variable "region" {
  type        = string
  description = "AWS region to create resources"
  default     = "eu-central-1"
}

variable "github_website_repository" {
  type        = string
  description = "Github repository hosting fe code."
  default     = "pagopa/site-pagopa.gov.it"
}

variable "github_infra_repository" {
  type        = string
  description = "This github repository."
  default     = "pagopa/pagopa.gov.it-infrastructure"
}


variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}