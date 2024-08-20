# AWS IAM Identity Center ABAC Module

## Usage
```hcl
module "sso_abac" {
  source                 = "./modules/aws-sso-abac-access"

  policy_name            = "my-permission-set"
  aws_account_identifier = "123456789012" # change to your account number
  
  attributes             = ["CostCenter", "Organization", "Division"]
  actions_no_tags        = ["ec2:DescribeInstances"]
  actions_matching_tags  = ["ec2:StartInstances", "ec2:StopInstances"]
}
```

## Overview
From the AWS IAM Identity Center User Guide ([link](https://docs.aws.amazon.com/singlesignon/latest/userguide/abac.html)): 

> Attribute-based access control (ABAC) is an authorization strategy that defines permissions based on attributes. 
> You can use IAM Identity Center to manage access to your AWS resources across multiple AWS accounts using user 
> attributes that come from any IAM Identity Center identity source. In AWS, these attributes are called tags. 
> Using user attributes as tags in AWS helps you simplify the process of creating fine-grained permissions in 
> AWS and ensures that your workforce gets access only to the AWS resources with matching tags.

A user should be able to create a new project that:
* Contains all permission sets for a project
* Defines individual permission sets as inline policies
* Replicates or defines customer policies
* Include a variable for a tag that will only allows access to resources with same tag

## Considerations
* Customise inline policies to attach to users or groups and filter through them.
* Implement ABAC in other services and resources:
    * Resources like EC2 instances. Could potentially try an S3 bucket again.
    * Automate that process for creating and applying the role. 
    * Tag the roles and users.
* Check if actions could be a wildcard or if you have to specify the actions.
For example, could you use `[*]` instead of something like `ec2:ListInstances`.
* Check if roles have to be given tags manually or if they can be automatically
applied whenever a new SSO instance is given.

> **NOTE**
> When playing with IAM SSO and Terraform State. Always have an admin account 
> assigned to the managedment account outside of Terraform state, in case you
> make the mistake of removing all access. If pushing a change altering or 
> going near admin permission sets and the management account push it from 
> another user, or use a use/role with keys.

## Prerequisites
### Enabling and Configuring Attributes for Access Control
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
```

## Knowledge Base
* [1.0 ABAC Policy Structure](./docs/1-abac-policies.md)
* [2.0 Services compatible with ABAC](./docs/2-abac-compatible-services.md)
* [3.0 Attribute Mappings](./docs/3-attribute-mappings.md)
* [4.0 References](./docs/4-references.md)

## Requirements
| Name | Version |
|------|---------|
| [Terraform](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_terraform) | >= 1.0|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |

## Providers
| Name | Version |
|------|---------|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |

## Modules
No modules.

## Resources
| Name | Type |
|------|---------|
| [aws_ssoadmin_account_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_instance_access_control_attributes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_instance_access_control_attributes) | resource |
| [aws_ssoadmin_permission_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_identitystore_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | data source |
| [aws_ssoadmin_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |
| [aws_ssoadmin_permission_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_permission_set) | data source |
