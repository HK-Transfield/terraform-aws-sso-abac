# AWS IAM Identity Center Sync
---
## Project Template outline
A user should be able to create a new project that:
* Contains all permission sets for a project
* Define individual permission sets as inline policies
* Either replicate or define customer policies
* Include a variable for a tag that will only allows access to resources with same tag

## To-do
* Customise inline policies to attach to users or groups
* Filter through them

> **NOTE**
> When playing with IAM SSO and Terraform State. Always have an admin account 
> assigned to the managedment account outside of Terraform state, in case you
> make the mistake of removing all access.
>
> If pushing a change altering or going near admin permission sets and the 
> management account push  it from another user, or use a use/role with keys.
---
## Useful links
- [Data Source: aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)

- [Managed policies and inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)

- [IAM JSON policy elements: Condition](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition.html)

- [Permission sets](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html)

- [How do I use the PrincipalTag, ResourceTag, RequestTag, and TagKeys condition keys to create an IAM policy for tag-based restriction?](https://repost.aws/knowledge-center/iam-tag-based-restriction-policies)

- [AWS global condition context keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html#condition-keys-principaltag)