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

output "csm_cert_nacked_name" {
  value = aws_acm_certificate.static_bucket_certificate.domain_name
}

/*
output "csm_cert_name" {
  value = aws_acm_certificate.www_static_bucket_certificate.domin_name
}
*/
