# AWS IAM Identity Center ABAC Module

## Usage
```hcl
module "aws_sso_abac" {
  source                 = "./modules/aws-sso-abac-access"

  permission_name        = "my-permission-set"
  aws_account_identifier = ["123456789012"] # change to your account number
  
  attributes           = ["CostCenter", "Organization", "Division"]
  actions_readonly     = ["ec2:DescribeInstances"]
  actions_conditional  = ["ec2:StartInstances", "ec2:StopInstances"]
}
```

## Overview
From the AWS IAM Identity Center User Guide ([link](https://docs.aws.amazon.com/singlesignon/latest/userguide/abac.html)): 

> Attribute-based access control (ABAC) is an authorization strategy that defines permissions based on attributes. 
> You can use IAM Identity Center to manage access to your AWS resources across multiple AWS accounts using user 
> attributes that come from any IAM Identity Center identity source. In AWS, these attributes are called tags. 
> Using user attributes as tags in AWS helps you simplify the process of creating fine-grained permissions in 
> AWS and ensures that your workforce gets access only to the AWS resources with matching tags.

<!-- With this module, you should be able to create a new project that:
* Contains all permission sets for a given project
* Defines individual permission sets as inline policies
* Replicates or defines customer policies
* Includes a variable for a tag/attribute that will only allows access to resources with same tag -->

<!-- ## Considerations
* Customise inline policies to attach to users or groups and filter through them.
* Implement ABAC in other services and resources:
    * Resources like EC2 instances. Could potentially try an S3 bucket again.
    * Automate that process for creating and applying the role. 
    * Tag the roles and users.
* Check if actions could be a wildcard or if you have to specify the actions.
For example, could you use `[*]` instead of something like `ec2:ListInstances`.
* Check if roles have to be given tags manually or if they can be automatically
applied whenever a new SSO instance is given. -->

## Prerequisites
### Enabling and Configuring Attributes for Access Control

<!-- > **NOTE:**
> When working with IAM Identity Center and Terraform State, always have an admin account 
> assigned to the management account outside of that Terraform State, in case you
> make the mistake of removing all access. If pushing a change altering or 
> going near admin permission sets and the management account push it from 
> another user, or use a use/role with keys. -->

The following Terraform code will enable ABAC within your IAM Identity Center instance. You can adjust 
the attributes to suit your needs. If you, instead, wish to enable and configure attributes for 
access control using the IAM Identity Center console or IAM Identity Center API, you can follow 
this [guide](https://docs.aws.amazon.com/singlesignon/latest/userguide/configure-abac.html).

```hcl
data "aws_ssoadmin_instances" "this" {}

locals {
  # Adjust to select the attributes for your ABAC configuration
  attributes = {
    "CostCenter"   = "$${path:enterprise.costCenter}"
    "Organization" = "$${path:enterprise.organization}"
    "Division"     = "$${path:enterprise.division}"
  }
}

resource "aws_ssoadmin_instance_access_control_attributes" "this" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]

  dynamic "attribute" {
    for_each = local.attributes
    content {
      key = attribute.key
      value {
        source = [attribute.value]
      }
    }
  }
}

module "aws_sso_abac" {
  source                 = "./modules/aws-sso-abac-access"

  permission_name        = "my-permission-set"
  aws_account_identifier = ["123456789012"] # change to your account number
  
  attributes           = ["CostCenter", "Organization", "Division"]
  actions_readonly     = ["ec2:DescribeInstances"]
  actions_conditional  = ["ec2:StartInstances", "ec2:StopInstances"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.58.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_account_assignment.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/iam_policy_document) | data source |
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/identitystore_user) | data source |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/ssoadmin_instances) | data source |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/ssoadmin_permission_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_identifiers"></a> [account\_identifiers](#input\_account\_identifiers) | A 10-12 digit string used to identify AWS accounts | `list(string)` | n/a | yes |
| <a name="input_actions_conditional"></a> [actions\_conditional](#input\_actions\_conditional) | Actions allowed on a resource when the principal tags match the resource | `list(string)` | n/a | yes |
| <a name="input_actions_readonly"></a> [actions\_readonly](#input\_actions\_readonly) | Actions allowed on a resource, regardless of what tags the principal has | `list(string)` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | A list of user attributes to use in policies to control access to resources | `map(string)` | `{}` | no |
| <a name="input_permission_set_desc"></a> [permission\_set\_desc](#input\_permission\_set\_desc) | A description for the inline policy | `string` | `""` | no |
| <a name="input_permission_set_name"></a> [permission\_set\_name](#input\_permission\_set\_name) | The name of the inline policy created for a single IAM identity | `string` | n/a | yes |
| <a name="input_principal_name"></a> [principal\_name](#input\_principal\_name) | The name of the principal to assign the permission set to | `string` | `""` | no |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | The entity type for which the assignment will be created | `string` | n/a | yes |
| <a name="input_resources_conditional"></a> [resources\_conditional](#input\_resources\_conditional) | Resources users can perform actions on when the tags match | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_resources_readonly"></a> [resources\_readonly](#input\_resources\_readonly) | Resources users are allowed to read-only | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | Session Timeout for SSO | `string` | `"PT1H"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_assignment"></a> [account\_assignment](#output\_account\_assignment) | All account assignments made |
| <a name="output_permission_set_arn"></a> [permission\_set\_arn](#output\_permission\_set\_arn) | The Amazon Resource Number (ARN) of the custom permission set |
| <a name="output_permission_set_created_date"></a> [permission\_set\_created\_date](#output\_permission\_set\_created\_date) | The date the Permission Set was created in RFC3339 format |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID that has the custom permission set attached to it |
<!-- END_TF_DOCS -->