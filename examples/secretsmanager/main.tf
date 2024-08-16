data "aws_iam_policy_document" "access_same_project_team" {
  statement {
    sid       = "AllActionsSecretsManagerSameProjectSameTeam"
    effect    = "Allow"
    actions   = ["secretsmanager:*"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/access-project"
      values   = ["$${aws:PrincipalTag/access-project}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/access-team"
      values   = ["$${aws:PrincipalTag/access-team}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/cost-center"
      values   = ["$${aws:PrincipalTag/cost-center}"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"

      values = [
        "access-project",
        "access-team",
        "cost-center",
        "Name",
        "OwnedBy",
      ]
    }

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/access-project"
      values   = ["$${aws:PrincipalTag/access-project}"]
    }

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/access-team"
      values   = ["$${aws:PrincipalTag/access-team}"]
    }

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/cost-center"
      values   = ["$${aws:PrincipalTag/cost-center}"]
    }
  }

  statement {
    sid       = "AllResourcesSecretsManagerNoTags"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:ListSecrets",
    ]
  }

  statement {
    sid       = "ReadSecretsManagerSameTeam"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "secretsmanager:Describe*",
      "secretsmanager:Get*",
      "secretsmanager:List*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/access-team"
      values   = ["$${aws:PrincipalTag/access-team}"]
    }
  }

  statement {
    sid       = "DenyUntagSecretsManagerReservedTags"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["secretsmanager:UntagResource"]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:TagKeys"
      values   = ["access-*"]
    }
  }

  statement {
    sid       = "DenyPermissionsManagement"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["secretsmanager:*Policy"]
  }
}