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
      version = "~> 3.63.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "static_bucket" {
  bucket = var.domain_name
  acl    = "public-read"

  force_destroy = true

  website {
    index_document = "index.html"
  }

  /*
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
  */
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

resource "aws_cloudfront_origin_access_identity" "access_identity" {
  comment = "Restrict access to cloud front"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = [format("%s/*", aws_s3_bucket.static_bucket.arn)]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
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