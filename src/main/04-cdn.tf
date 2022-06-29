## CDN ##

resource "aws_cloudfront_origin_access_identity" "access_identity" {
  comment = "Restrict access to cloud front"
}

/*
resource "aws_cloudfront_response_headers_policy" "cors" {
  name    = "cors-policy"
  comment = "test comment"

  cors_config {
    access_control_allow_credentials = true


    access_control_allow_methods {
      items = ["GET"]
    }

    access_control_allow_origins {
      items = ["*.pagopa.it"]
    }

    origin_override = true
  }
}
*/
resource "aws_cloudfront_distribution" "static_bucket_distribution" {
  origin {

    domain_name = aws_s3_bucket.static_bucket.website_endpoint
    origin_id   = var.domain_name
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
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

  aliases = [format("www.%s", replace(var.domain_name, "-", "."))]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.www_static_bucket_certificate.arn
    ssl_support_method  = "sni-only"
  }

  tags = var.tags

}

