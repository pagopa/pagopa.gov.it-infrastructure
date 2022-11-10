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

output "cdn_static_bucket_distribution_id" {
  value = aws_cloudfront_distribution.static_bucket_distribution.id
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

output "cert_domain_validation_options" {
  value = aws_acm_certificate.static_bucket_certificate.domain_validation_options
}

output "cert_www_domain_validation_options" {
  value = aws_acm_certificate.www_static_bucket_certificate.domain_validation_options
}

output "global_accelerator_addresses" {
  value = aws_globalaccelerator_accelerator.alb_ga.ip_sets[0]["ip_addresses"]
}

output "alb_" {
  value = aws_lb.fe_alb.dns_name
}

output "iam_role_deploy_arn" {
  value = data.terraform_remote_state.shared.outputs.iam_role_deploy_arn
}

output "iam_role_deploy_name" {
  value = data.terraform_remote_state.shared.outputs.iam_role_deploy_name
}