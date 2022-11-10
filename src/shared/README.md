## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.63.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_budget_alert"></a> [budget\_alert](#module\_budget\_alert) | hazelops/budget-alert/aws |  |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.circle_ci_access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.cleancdncache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.githubdeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.test-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.circle_ci_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.circle_ci_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_secretsmanager_secret.slack_io_status](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.slack_io_status_lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Github repository hosting fe code. | `string` | `"pagopa/site-pagopa.gov.it"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to create resources | `string` | `"eu-central-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_circle_ci_user_name"></a> [circle\_ci\_user\_name](#output\_circle\_ci\_user\_name) | n/a |
| <a name="output_iam_role_deploy_arn"></a> [iam\_role\_deploy\_arn](#output\_iam\_role\_deploy\_arn) | n/a |
| <a name="output_iam_role_deploy_name"></a> [iam\_role\_deploy\_name](#output\_iam\_role\_deploy\_name) | n/a |
