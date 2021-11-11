output "static_bucket_arn" {
  value = aws_s3_bucket.static_bucket.arn
}

output "static_bucket_regional_domain_name" {
  value = aws_s3_bucket.static_bucket.bucket_regional_domain_name
}


output "static_bucket_website_domain" {
  value = aws_s3_bucket.static_bucket.website_domain
}

output "static_bucket_website_endpoint" {
  value = aws_s3_bucket.static_bucket.website_endpoint
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

output "csm_cert_www_name" {
  value = aws_acm_certificate.www_static_bucket_certificate.domain_name
}

output "circle_ci_access_key" {
  value = aws_iam_access_key.circle_ci_access_key.id
}

output "circle_ci_access_key_secret" {
  value     = aws_iam_access_key.circle_ci_access_key.secret
  sensitive = true
}
