output "iam_role_deploy_arn" {
  value = aws_iam_role.githubdeploy.arn
}

output "iam_role_deploy_name" {
  value = aws_iam_role.githubdeploy.name
}

output "iam_role_iac_arn" {
  value = aws_iam_role.githubiac.arn
}

output "iam_role_iac_name" {
  value = aws_iam_role.githubiac.name
}