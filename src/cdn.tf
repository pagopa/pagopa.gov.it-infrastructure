## CDN ##

resource "aws_cloudfront_origin_access_identity" "access_identity" {
  comment = "Restrict access to cloud front"
}

resource "aws_cloudfront_distribution" "static_bucket_distribution" {
  origin {

    domain_name = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_id   = var.domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.domain_name
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  aliases = ["www.test.pagopa.gov.it"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  /*
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  */

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.www_static_bucket_certificate.arn
    ssl_support_method  = "sni-only"
  }

}