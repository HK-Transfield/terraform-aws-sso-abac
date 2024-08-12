# AWS IAM Identity Center Sync and ABAC

## Overview
Attribute-based access control (ABAC) is an authorization strategy that defines permissions based
on attributes or *tags*. Tags can be attached to IAM users or roles, and to AWS resources. You can
define policies using tag condition keys to grant permissions to your principals based on their tags.


## Project Template outline
A user should be able to create a new project that:
* Contains all permission sets for a project
* Define individual permission sets as inline policies
* Either replicate or define customer policies
* Include a variable for a tag that will only allows access to resources with same tag

## ABAC Policies
> **IMPORTANT**
> Policies using the following strategy allow *all* actions for a service, but explicitly deny 
> permissions-altering actions. Denying actions overrides any other policies allowing the principal 
> to perform that action. This can have unintended results. The best practice is to use explicit 
> denies only when there is no circumstance that should allow that action. Otherwise, allow a list 
> of individual actions, and the unwanted actions are denied by default. 

Policies that allow for ABAC based on permissions should allow principals to create, edit, and delete resources with values that match the principal's tags. These Policies can be divided into multiple statements:
1. ***Allow*** all of a service's actions on all related resources if the resource tags match the principal tags.
2. ***Allow*** certain of a service's actions on all related resources if there are no resource tags.
3. ***Allow*** read-only operations if the principal is tagged with the same access tag as the resource.
4. ***Deny*** requests to move tags with keys beginning with a certain string. These tags control resouce access; therefore, removing tags removes permissions.
5. ***Deny*** access to create, edit, or delete resource-based policies. These policies could be used to change the permissions of the secret.

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

---
## Useful links

### Terraform Registry
- [Data Source: aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)


### AWS User Guides & Tutorials
- [IAM tutorial: Define permissions to access AWS resources based on tags](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_attribute-based-access-control.html)

- [Permission sets](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html)

- [Managed policies and inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)

- [IAM JSON policy elements: Condition](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition.html)

- [AWS global condition context keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html#condition-keys-principaltag)

### AWS Knowledge Center
- [How do I use the PrincipalTag, ResourceTag, RequestTag, and TagKeys condition keys to create an IAM policy for tag-based restriction?](https://repost.aws/knowledge-center/iam-tag-based-restriction-policies)