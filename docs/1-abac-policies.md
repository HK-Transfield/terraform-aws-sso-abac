# 1.0 ABAC Policies
> **IMPORTANT**
> Policies using the following strategy allow *all* actions for a service, but explicitly deny 
> permissions-altering actions. Denying actions overrides any other policies allowing the principal 
> to perform that action. This can have unintended results. The best practice is to use explicit 
> denies only when there is no circumstance that should allow that action. Otherwise, allow a list 
> of individual actions, and the unwanted actions are denied by default. 

Policies that allow for ABAC based on permissions should allow principals to create, edit, and delete resources with values that match the principal's tags. These Policies can be divided into multiple statements.

## 1.1 Matching Principal and Resource Tags
This statement **ALLOWS** all of a service's actions on all related resources if the resource tags match the principal tags.
```hcl
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

## 1.2 No Resource Tags
This statement **ALLOWS** certain of a service's actions on all related resources if there are no resource tags.
```hcl
statement {
    sid       = "AllResources<AWS_SERVICE>NoTags"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<ACTION>"]
  }
```

## 1.3 Matching a Principal tag
This statement **ALLOWS** read-only operations if the principal is tagged with the same access tag as the resource.
```hcl
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

## 1.4 Requests to Remove Tags
This statement **DENIES** requests to remove tags with keys beginning with a certain string. These tags control resouce access; therefore, removing tags removes permissions.
```hcl
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

## 1.5 Resource Permissions Management
This statement **DENIES** access to create, edit, or delete resource-based policies. These policies could be used to change the permissions of the resource.
```hcl
statement {
    sid       = "DenyPermissionsManagement"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:*Policy"]
  }
```