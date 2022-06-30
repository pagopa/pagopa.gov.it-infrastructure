variable "env_short" {
  type        = string
  description = "Short environment identified. eg: d,p,t,u"
  default     = "d"
}

variable "domain_name" {
  type        = string
  description = "Website root domain name"
}

variable "region" {
  type        = string
  description = "AWS region to create resources"
  default     = "eu-central-1"
}

variable "access_control_allow_origins" {
  type        = list(string)
  description = "List of origins allowed to query the site."
  default     = ["status.pagopa.gov.it"]

}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}