# AWS IAM Identity Center Sync and ABAC

## 1.0 Overview
Attribute-based access control (ABAC) is an authorization strategy that defines permissions based
on attributes or *tags*. Tags can be attached to IAM users or roles, and to AWS resources. You can
define policies using tag condition keys to grant permissions to your principals based on their tags.


## 2.0 Project Outline
A user should be able to create a new project that:
* Contains all permission sets for a project
* Defines individual permission sets as inline policies
* Replicates or defines customer policies
* Include a variable for a tag that will only allows access to resources with same tag

### 2.1 ABAC Policies
> **IMPORTANT**
> Policies using the following strategy allow *all* actions for a service, but explicitly deny 
> permissions-altering actions. Denying actions overrides any other policies allowing the principal 
> to perform that action. This can have unintended results. The best practice is to use explicit 
> denies only when there is no circumstance that should allow that action. Otherwise, allow a list 
> of individual actions, and the unwanted actions are denied by default. 

Policies that allow for ABAC based on permissions should allow principals to create, edit, and delete resources with values that match the principal's tags. These Policies can be divided into multiple statements.

#### 2.1.1 Matching Principal and Resource Tags
This statement **ALLOWS** all of a service's actions on all related resources if the resource tags match the principal tags.
```
statement {
    sid       = "AllActions<AWS_SERVICE>SameTags"
    effect    = "Allow"
    actions   = ["<AWS_SERVICE>:*"]
    resources = ["*"]

    # Add a condition block for every tag you assign a resource
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/tag1"
      values   = ["$${aws:PrincipalTag/tag1}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/tag2"
      values   = ["$${aws:PrincipalTag/tag2}"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"

      # List the tag keys
      values = [
        "tag1",
        "tag2"
      ]
    }

    # Add a condition block for every tag you assign a resource
    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/tag1"
      values   = ["$${aws:PrincipalTag/tag1}"]
    }

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/tag2"
      values   = ["$${aws:PrincipalTag/tag2}"]
    }
  }
```

#### 2.1.2 No Resource Tags
This statement **ALLOWS** certain of a service's actions on all related resources if there are no resource tags.
```
statement {
    sid       = "AllResources<AWS_SERVICE>NoTags"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<ACTION>"]
  }
```

#### 2.1.3 Matching a Principal tag
This statement **ALLOWS** read-only operations if the principal is tagged with the same access tag as the resource.
```
statement {
    sid       = "Read<AWS_SERVICE>SameTag"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<READ_ONLY_OPS>*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/tag1"
      values   = ["$${aws:PrincipalTag/tag1}"]
    }
  }
```

#### 2.1.4 Requests to Remove Tags
This statement **DENIES** requests to remove tags with keys beginning with a certain string. These tags control resouce access; therefore, removing tags removes permissions.
```
statement {
    sid       = "DenyUntag<AWS_SERVICE>ReservedTags"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<ACTION>"]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:TagKeys"
      values   = ["<SOME_STRING>*"]
    }
  }
```

#### 2.1.5 Resource Permissions Management
This statement **DENIES** access to create, edit, or delete resource-based policies. These policies could be used to change the permissions of the resource.
```
statement {
    sid       = "DenyPermissionsManagement"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:*Policy"]
  }
```

## 3.0 Considerations
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

## 4.0 Resources/Services that allow for ABAC
| Resource/Service | ABAC Access |
|------|---------|
| |  |

## 5.0 Requirements
| Name | Version |
|------|---------|
| [Terraform](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_terraform) | >= 1.0|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |

## 5.0 Providers
| Name | Version |
|------|---------|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |

## Useful links

### Terraform Registry
- [Data Source: aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)

- [Resource: aws_ssoadmin_instance_access_control_attributes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_instance_access_control_attributes)


### AWS User Guides & Tutorials
- [IAM tutorial: Define permissions to access AWS resources based on tags](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_attribute-based-access-control.html)

- [Permission sets](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html)

- [Managed policies and inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)

- [IAM JSON policy elements: Condition](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition.html)

- [AWS global condition context keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html#condition-keys-principaltag)

- [Determining whether a request is allowed or denied within an account](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html#policy-eval-denyallow)

- [Define permissions based on attributes with ABAC authorization](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html)

- [AWS global condition context keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html)

- [AWS services that work with IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html)

- [Attributes for access control](https://docs.aws.amazon.com/singlesignon/latest/userguide/attributesforaccesscontrol.html)

- [Checklist: Configuring ABAC in AWS using IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/abac-checklist.html)

- [Enable and configure attributes for access control](https://docs.aws.amazon.com/singlesignon/latest/userguide/configure-abac.html)

- [Attribute mappings for AWS Managed Microsoft AD directory](https://docs.aws.amazon.com/singlesignon/latest/userguide/attributemappingsconcept.html#defaultattributemappings)

- [Create permission policies for ABAC in IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/configure-abac-policies.html)

### AWS Knowledge Center
- [How do I use the PrincipalTag, ResourceTag, RequestTag, and TagKeys condition keys to create an IAM policy for tag-based restriction?](https://repost.aws/knowledge-center/iam-tag-based-restriction-policies)

### Other websites
- [The state of ABAC on AWS (in 2024)](https://ramimac.me/abac)
