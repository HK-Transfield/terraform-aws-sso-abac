# AWS IAM Identity Center Sync and ABAC

## Overview
Attribute-based access control (ABAC) is an authorization strategy that defines permissions based
on attributes or *tags*. Tags can be attached to IAM users or roles, and to AWS resources. You can
define policies using tag condition keys to grant permissions to your principals based on their tags.

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
> make the mistake of removing all access.
>
> If pushing a change altering or going near admin permission sets and the 
> management account push  it from another user, or use a use/role with keys.

## Requirements
| Name | Version |
|------|---------|
| [Terraform](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_terraform) | >= 1.0|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |

## Providers
| Name | Version |
|------|---------|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |