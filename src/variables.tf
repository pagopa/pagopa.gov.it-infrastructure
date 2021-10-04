variable "domain_name" {
  type        = string
  description = "Website root domain name"
}

variable "region" {
  type        = string
  description = "AWS region to create resources"
  default     = "eu-central-1"
}
