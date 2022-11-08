variable "region" {
  type        = string
  description = "AWS region to create resources"
  default     = "eu-central-1"
}

variable "github_repository" {
  type        = string
  description = "Github repository hosting fe code."
  default     = "pagopa/site-pagopa.gov.it"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}