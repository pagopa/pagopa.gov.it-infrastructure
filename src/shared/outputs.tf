output "circle_ci_user_name" {
  value = aws_iam_user.circle_ci_user.name
}
output "circle_ci_access_key" {
  value = aws_iam_access_key.circle_ci_access_key.id
}

output "circle_ci_access_key_secret" {
  value     = aws_iam_access_key.circle_ci_access_key.secret
  sensitive = true
}