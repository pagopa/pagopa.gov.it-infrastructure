resource "aws_s3_bucket" "static_bucket" {
  bucket = var.domain_name
  acl    = "public-read"

  force_destroy = true

  website {
    index_document = "index.html"
    # todo: improvement: set the 404 custom error page as fallback in cloud front.
    error_document = "404.html"

  }

  cors_rule {
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*.pagopa.it"]
    max_age_seconds = 3000
  }

  tags = var.tags
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

# Creates policy to allow public access to the S3 bucket
resource "aws_s3_bucket_policy" "update_website_root_bucket_policy" {
  bucket = aws_s3_bucket.static_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForWebsiteEndpointsPublicContent",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.static_bucket.arn}/*",
        "${aws_s3_bucket.static_bucket.arn}"
      ]
    }
  ]
}
POLICY
}