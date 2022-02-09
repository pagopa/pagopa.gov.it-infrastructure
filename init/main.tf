provider "aws" {
  region = var.region
}

locals {
  tags = merge(var.tags, {
    Environment : var.environment,
    Owner : "PagoPa",
    Source : "https://github.com/uolter/terraform-aws-example.git"
  })
}

# terraform state file setup
# create an S3 bucket to store the state file in

resource "random_integer" "bucket_suffix" {
  min = 1
  max = 9999
}
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = format("terraform-backend-%4f", random_integer.bucket_suffix.result)


  versioning {
    # enable with caution, makes deleting S3 buckets tricky
    enabled = false
  }

  lifecycle {
    prevent_destroy = true
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