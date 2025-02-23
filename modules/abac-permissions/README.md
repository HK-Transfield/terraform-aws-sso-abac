<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_account_assignment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_ssoadmin_account_assignment.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_account_assignment) | data source |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_permission_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_identifiers"></a> [account\_identifiers](#input\_account\_identifiers) | A 10-12 digit string used to identify AWS accounts | `list(string)` | n/a | yes |
| <a name="input_actions_conditional"></a> [actions\_conditional](#input\_actions\_conditional) | Actions allowed on a resource when the principal tags match the resource | `list(string)` | n/a | yes |
| <a name="input_actions_readonly"></a> [actions\_readonly](#input\_actions\_readonly) | Actions allowed on a resource, regardless of what tags the principal has | `list(string)` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | A list of user attributes to use in policies to control access to resources | `map(string)` | `{}` | no |
| <a name="input_permission_set_desc"></a> [permission\_set\_desc](#input\_permission\_set\_desc) | A description for the inline policy | `string` | `""` | no |
| <a name="input_permission_set_name"></a> [permission\_set\_name](#input\_permission\_set\_name) | The name of the inline policy created for a single IAM identity | `string` | n/a | yes |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | The unique identifier of the principal to assign the permission set to | `string` | `""` | no |
| <a name="input_principal_name"></a> [principal\_name](#input\_principal\_name) | The name of the principal to assign the permission set to | `string` | `""` | no |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | The entity type for which the assignment will be created | `string` | `"GROUP"` | no |
| <a name="input_resources_conditional"></a> [resources\_conditional](#input\_resources\_conditional) | Resources users can perform actions on when the tags match | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_resources_readonly"></a> [resources\_readonly](#input\_resources\_readonly) | Resources users are allowed to read-only | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | Session Timeout for SSO | `string` | `"PT1H"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources created by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_assignment"></a> [account\_assignment](#output\_account\_assignment) | All account assignments made |
| <a name="output_permission_set_arn"></a> [permission\_set\_arn](#output\_permission\_set\_arn) | The Amazon Resource Number (ARN) of the custom permission set |
| <a name="output_permission_set_created_date"></a> [permission\_set\_created\_date](#output\_permission\_set\_created\_date) | The date the Permission Set was created in RFC3339 format |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID that has the custom permission set attached to it |
<!-- END_TF_DOCS -->