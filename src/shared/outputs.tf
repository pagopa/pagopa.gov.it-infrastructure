output "circle_ci_user_name" {
  value = aws_iam_user.circle_ci_user.name
}

output "iam_role_deploy_arn" {
  value = aws_iam_role.githubdeploy.arn
}

output "iam_role_deploy_name" {
  value = aws_iam_role.githubdeploy.name
}