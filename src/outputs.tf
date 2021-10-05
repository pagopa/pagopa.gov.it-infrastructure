output "static_bucket_arn" {
  value = aws_s3_bucket.static_bucket.arn
}

output "static_bucket_regional_domain_name" {
  value = aws_s3_bucket.static_bucket.bucket_regional_domain_name
}

output "cdn_static_bucket_arn" {
  value = aws_cloudfront_distribution.static_bucket_distribution.arn
}

output "cdn_static_bucket_domain_name" {
  value = aws_cloudfront_distribution.static_bucket_distribution.domain_name
}