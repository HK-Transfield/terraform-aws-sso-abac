data "aws_iam_policy_document" "abac" {

  /* 1. ALLOW all of a service's actions on all related resources if the resource tags match the principal tags.*/
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

  /* 2. ALLOW certain of a service's actions on all related resources if there are no resource tags. */
  statement {
    sid       = "AllResources<AWS_SERVICE>NoTags"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<ACTION>"]
  }

  /* 3. ALLOW read-only operations if the principal is tagged with the same access tag as the resource. */
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

  /* 4. DENY requests to move tags with keys beginning with a certain string. These tags control resouce access; therefore, removing tags removes permissions. */
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
  /* 5. DENY access to create, edit, or delete resource-based policies. These policies could be used to change the permissions of the resource. */
  statement {
    sid       = "DenyPermissionsManagement"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:*Policy"]
  }
}