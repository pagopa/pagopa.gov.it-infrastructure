variable "region" {
  type        = string
  description = "AWS region (default is Milan)"
  default     = "eu-south-1"
}

variable "environment" {
  type        = string
  description = "Environment. Possible values are: Dev, Uat, Prod"
  default     = "Dev"
}


variable "tags" {
  type = map(any)
  default = {
    "CreatedBy" : "Terraform",
    "Environment" : "Prod"
  }
}