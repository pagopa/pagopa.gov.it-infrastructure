output "backend_bucket_name" {
  value = aws_s3_bucket.terraform-state-storage-s3.bucket
}

output "dynamodb_lock_table" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.name
}