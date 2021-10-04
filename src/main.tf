terraform {
  required_version = ">= 1.0.0"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "PagoPa"

    workspaces {
      name = "pagopa-gov-it"
    }
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.61.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_s3_bucket" "static_bucket" {
  bucket = var.domain_name
  acl    = "public-read"

  force_destroy = true

  website {
    index_document = "index.html"
  }

  policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "PublicReadGetObject",
              "Effect": "Allow",
              "Principal": "*",
              "Action": [
                  "s3:GetObject"
              ],
              "Resource": [
                  "arn:aws:s3:::${var.domain_name}/*"
              ]
          }
      ]
    }
  EOT
}


resource "aws_acm_certificate" "static_bucket_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*
resource "aws_acm_certificate_validation" "static_bucket_certificate" {
  certificate_arn = aws_acm_certificate.static_bucket_certificate.arn
  timeouts {
    create = "20m"
  }
}
*/

## CDN ##
resource "aws_cloudfront_distribution" "static_bucket_distribution" {
  origin {
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = aws_s3_bucket.static_bucket.website_endpoint
    origin_id   = var.domain_name
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

  #aliases = [var.domain_name]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  /*
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.static_bucket_certificate.certificate_arn
    ssl_support_method  = "sni-only"
  }
  */
}

/*
resource "aws_route53_record" "static_bucket_record" {
  zone_id = data.aws_route53_zone.static_bucket_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_bucket_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.static_bucket_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_iam_user" "circle_ci_user" {
  name = "circle-ci"
}

resource "aws_iam_access_key" "circle_ci_access_key" {
  user = aws_iam_user.circle_ci_user.name
}

resource "aws_iam_user_policy" "circle_ci_policy" {
  name = "circle-ci-policy"
  user = aws_iam_user.circle_ci_user.name

  policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "s3:*",
              "Resource": [
                  "arn:aws:s3:::${var.domain_name}",
                  "arn:aws:s3:::${var.domain_name}/*"
              ]
          }
      ]
    }
  EOT
}

*/