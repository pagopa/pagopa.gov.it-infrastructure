data "aws_secretsmanager_secret" "io_operation" {
  name = "operation/alerts"
}

data "aws_secretsmanager_secret_version" "io_operation_lt" {
  secret_id = data.aws_secretsmanager_secret.io_operation.id
}


resource "aws_sns_topic" "alarms" {
  provider     = aws.us-east-1
  name         = "alarms"
  display_name = "alarms"
}

resource "aws_sns_topic_subscription" "alarms_email" {
  endpoint               = jsondecode(data.aws_secretsmanager_secret_version.io_operation_lt.secret_string)["email"]
  endpoint_auto_confirms = true
  protocol               = "email"
  topic_arn              = aws_sns_topic.alarms.arn
}


resource "aws_cloudwatch_metric_alarm" "cdn_error_rate" {
  provider            = aws.us-east-1
  alarm_name          = "cdn_error_rate"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TotalErrrorRate"
  namespace           = "AWS/CloudFront"
  period              = "60"
  datapoints_to_alarm = 1
  statistic           = "Average"
  threshold           = 2
  alarm_description   = "CDN Error rate grather than 2%"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    DistributionId = aws_cloudfront_distribution.static_bucket_distribution.id
    Region         = "Global"
  }
}
