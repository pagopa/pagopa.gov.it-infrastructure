## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.63.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | ~> 3.63.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws |  |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.static_bucket_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.www_static_bucket_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_alb_listener.front_end](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.http_to_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_cloudfront_distribution.static_bucket_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.access_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_globalaccelerator_accelerator.alb_ga](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_accelerator) | resource |
| [aws_globalaccelerator_endpoint_group.alb_ga_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_endpoint_group) | resource |
| [aws_globalaccelerator_listener.alb_ga_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_listener) | resource |
| [aws_iam_user_policy.circle_ci_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_lb.fe_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_s3_bucket.static_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.update_website_root_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_allow_all_nsg_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_http_nsg_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_https_nsg_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_availability_zones.az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [terraform_remote_state.shared](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Website root domain name | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | Short environment identified. eg: d,p,t,u | `string` | `"d"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to create resources | `string` | `"eu-central-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cdn_static_bucket_arn"></a> [cdn\_static\_bucket\_arn](#output\_cdn\_static\_bucket\_arn) | n/a |
| <a name="output_cdn_static_bucket_distribution_id"></a> [cdn\_static\_bucket\_distribution\_id](#output\_cdn\_static\_bucket\_distribution\_id) | n/a |
| <a name="output_cdn_static_bucket_domain_name"></a> [cdn\_static\_bucket\_domain\_name](#output\_cdn\_static\_bucket\_domain\_name) | n/a |
| <a name="output_cert_domain_validation_options"></a> [cert\_domain\_validation\_options](#output\_cert\_domain\_validation\_options) | n/a |
| <a name="output_cert_www_domain_validation_options"></a> [cert\_www\_domain\_validation\_options](#output\_cert\_www\_domain\_validation\_options) | n/a |
| <a name="output_csm_cert_nacked_name"></a> [csm\_cert\_nacked\_name](#output\_csm\_cert\_nacked\_name) | n/a |
| <a name="output_csm_cert_www_name"></a> [csm\_cert\_www\_name](#output\_csm\_cert\_www\_name) | n/a |
| <a name="output_static_bucket_arn"></a> [static\_bucket\_arn](#output\_static\_bucket\_arn) | n/a |
| <a name="output_static_bucket_regional_domain_name"></a> [static\_bucket\_regional\_domain\_name](#output\_static\_bucket\_regional\_domain\_name) | n/a |
| <a name="output_static_bucket_website_domain"></a> [static\_bucket\_website\_domain](#output\_static\_bucket\_website\_domain) | n/a |
| <a name="output_static_bucket_website_endpoint"></a> [static\_bucket\_website\_endpoint](#output\_static\_bucket\_website\_endpoint) | n/a |
