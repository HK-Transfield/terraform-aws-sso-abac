/***************************************************************
  Title: AWS Attribute-based Access Control with Terraform

  Description: Defines permissions to access AWS resources
  based on tags (ABAC) This follows the tutorial found in 
  the AWS IAM User guide:
  https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_attribute-based-access-control.html

  Contributors: HK Transfield
****************************************************************/

# Grab the SSO instance data
# data "aws_ssoadmin_instances" "this" {} 

locals {
  peg_project = "peg" # Pegasus project
  uni_project = "uni" # Unicorn project
}

locals {
  eng_team = "eng" # Engineering team
  qas_team = "qas" # Quality Assurance team
}

locals {
  peg_cc = "987654"
  uni_cc = "123456"
}

/***************************************************************
  SECTION 1: Creating the Users

  To test ABAC, create users with permissions to assume roles
  with the same tags. This process makes it easier to add more
  users to a team.

  When tagging users, they automatically get access to assume
  the correct role.

  Users do not need to be added to the trust policy of the role
  if they work on only one project or team

****************************************************************/

# This policy allows a user to assume any role in an
# AWS account with the 'access-' name prefix. The 
# role must be tagged with the same project, team,
# and cost center tags as the user
data "aws_iam_policy_document" "access_assume_role" {
  statement {
    sid       = "AssumeRole"
    effect    = "Allow"
    resources = ["arn:aws:iam::${var.account_id}:role/access-*"]
    actions   = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/access-project"
      values   = ["$${aws:PrincipalTag/access-project}"]
    }

    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/access-team"
      values   = ["$${aws:PrincipalTag/access-team}"]
    }

    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/cost-center"
      values   = ["$${aws:PrincipalTag/cost-center}"]
    }
  }
}

resource "aws_iam_policy" "access_assume_role" {
  name   = "access-assume-role"
  policy = data.aws_iam_policy_document.access_assume_role.json
}

# Create an IAM group for scaling the number of users
resource "aws_iam_group" "this" {
  name = "assume-role-users"
  path = "/"
}

# Attach the 'access_assume_role' permissions policy
resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.access_assume_role.arn
}


# Create IAM users and add each user to the group
module "Arnav" {
  source = "./modules/IAM/abac-users"
  name   = "access-Arnav-peg-eng"
  groups = [aws_iam_group.this.name]

  tags = {
    access-project = local.peg_project
    access-team    = local.eng_team
    cost-center    = local.peg_cc
  }
}

module "Mary" {
  source = "./modules/IAM/abac-users"
  name   = "access-Mary-peg-qas"
  groups = [aws_iam_group.this.name]

  tags = {
    access-project = local.peg_project
    access-team    = local.qas_team
    cost-center    = local.peg_cc
  }
}

module "Saanvi" {
  source = "./modules/IAM/abac-users"
  name   = "access-Saanvi-uni-eng"
  groups = [aws_iam_group.this.name]

  tags = {
    access-project = local.uni_project
    access-team    = local.eng_team
    cost-center    = local.uni_cc
  }
}

module "Carlos" {
  source = "./modules/IAM/abac-users"
  name   = "access-Carlos-uni-qas"
  groups = [aws_iam_group.this.name]

  tags = {
    access-project = local.uni_project
    access-team    = local.qas_team
    cost-center    = local.uni_cc
  }
}

/***************************************************************
  SECTION 2: Creating the ABAC policy

****************************************************************/

# The policy allows principals to create, read, edit, and delete
# resources tagged with the same key-value pairs as the principal.
# When a principal creates a resource, they must add all tags with
# values matching the principal's tag.
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

resource "aws_iam_policy" "access_same_project_team" {
  name   = "access_same_project_team"
  policy = data.aws_iam_policy_document.access_same_project_team.json
}

data "aws_iam_policy_document" "access_same_s3" {
  statement {
    sid       = "AllActionsS3SameProjectSameTeam"
    effect    = "Allow"
    actions   = ["s3:*"]
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
    sid       = "ListBucketsAndObjects"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]

    actions = [
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
    ]
  }

  statement {
    sid       = "ReadObjectsSameTeam"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]

    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/access-team"
      values   = ["$${aws:PrincipalTag/access-team}"]
    }
  }

  statement {
    sid       = "DenyUntagS3ReservedTags"
    effect    = "Deny"
    resources = ["arn:aws:s3:::*"]
    actions   = ["s3:DeleteObjectTagging"]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:TagKeys"
      values   = ["access-*"]
    }
  }

  statement {
    sid       = "DenyBucketPolicyChanges"
    effect    = "Deny"
    resources = ["arn:aws:s3:::*"]
    actions   = ["s3:PutBucketPolicy"]
  }
}

resource "aws_iam_policy" "access_same_s3" {
  name   = "access_same_s3"
  policy = data.aws_iam_policy_document.access_same_s3.json
}

/***************************************************************
  SECTION 3: Creating roles

****************************************************************/

resource "aws_iam_role" "access_peg_eng" {
  name                = "access-peg-engineering"
  managed_policy_arns = [aws_iam_policy.access_same_project_team.arn, aws_iam_policy.access_same_s3.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "${var.account_id}"
        }
      },
    ]
  })

  tags = {
    access-project = local.peg_project
    access-team    = local.eng_team
    cost-center    = local.peg_cc
  }
}

resource "aws_iam_role" "access_peg_qas" {
  name                = "access-peg-quality-assurance"
  managed_policy_arns = [aws_iam_policy.access_same_project_team.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "${var.account_id}"
        }
      },
    ]
  })

  tags = {
    access-project = local.peg_project
    access-team    = local.qas_team
    cost-center    = local.peg_cc
  }
}

resource "aws_iam_role" "access_uni_eng" {
  name                = "access-uni-engineering"
  managed_policy_arns = [aws_iam_policy.access_same_project_team.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "${var.account_id}"
        }
      },
    ]
  })

  tags = {
    access-project = local.uni_project
    access-team    = local.eng_team
    cost-center    = local.uni_cc
  }
}

resource "aws_iam_role" "access_uni_qas" {
  name                = "access-uni-quality-assurance"
  managed_policy_arns = [aws_iam_policy.access_same_project_team.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "${var.account_id}"
        }
      },
    ]
  })

  tags = {
    access-project = local.uni_project
    access-team    = local.qas_team
    cost-center    = local.uni_cc
  }
}

/***************************************************************
  SECTION 4: Creating resources

  The attached permissions policy allows users to create
  resources. This is allowed only if the resource is 
  tagged with their project, team, and cost centre.

****************************************************************/