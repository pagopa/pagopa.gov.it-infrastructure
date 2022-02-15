provider "aws" {
  region = var.region
}

locals {
  tags = merge(var.tags, {
    Environment : var.environment,
    Owner : "PagoPa",
    Source : "https://github.com/pagopa/pagopa.gov.it-infrastructure.git",
    Scope : "tfstate",
  })
}

# terraform state file setup
# create an S3 bucket to store the state file in

resource "random_integer" "bucket_suffix" {
  min = 1
  max = 9999
}
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = format("terraform-backend-%04s", random_integer.bucket_suffix.result)


  versioning {
    # enable with caution, makes deleting S3 buckets tricky
    enabled = false
  }

  lifecycle {
    # prevent_destroy = true
  }

  tags = merge(local.tags, {
    name = "S3 Remote Terraform State Store"
  })
}

# create a DynamoDB table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 8
  write_capacity = 8

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(local.tags, {
    name = "DynamoDB Terraform State Lock Table"
  })

}

## IAM user who can manage the infrastructure definition

resource "aws_iam_group" "admins" {
  name = "Admins"
}


data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "admins" {
  group      = aws_iam_group.admins.name
  policy_arn = data.aws_iam_policy.admin_access.arn
}

resource "aws_iam_user" "iac" {
  name = "iac"

  tags = var.tags
}

resource "aws_iam_user_group_membership" "iac" {
  user = aws_iam_user.iac.name

  groups = [
    aws_iam_group.admins.name,
  ]
}