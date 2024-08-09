/*
Defines all permission sets used. This first section is for
all managed policies already provided by AWS.

Managed Policies:
  Administrator
  Billing-Administrator
  Database-Administrator
  DataScientist
  NetworkAdministrator
  PowerUserAccess
  ReadOnlyAccess
  SecurityAudit
  SupportUser
  SystemAdministrator
  ViewOnlyAccess
*/

data "aws_region" "this" {} # creates the account in whatever region the project is based in
# data "aws_ssoadmin_instances" "this" {}

locals {
  common_tags = {
    "Source" = "Implemented via Terraform - mgmt accnt"
  }
}

locals {
  session_duration = "PT1H"
}

## SECTION 1 - AWS MANAGED

# AWS-Administrator
resource "aws_ssoadmin_permission_set" "AWS-Administrator" {
  description      = "AWS-Administrator"
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name             = "AWS-Administrator"
  session_duration = local.session_duration
  tags             = local.common_tags
}

resource "aws_ssoadmin_managed_policy_attachment" "Administrator" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.AWS-Administrator.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_ssoadmin_permission_set" "AWS-Administrator" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = "AWS-Administrator"
  depends_on   = [aws_ssoadmin_permission_set.AWS-Administrator]
}

# AWS-Billing-Administrator
resource "aws_ssoadmin_permission_set" "AWS-Billing-Administrator" {
  description      = "AWS-Billing-Administrator"
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name             = "AWS-Billing-Administrator"
  session_duration = local.session_duration
  tags             = local.common_tags
}

resource "aws_ssoadmin_managed_policy_attachment" "Billing" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.AWS-Billing-Administrator.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

data "aws_ssoadmin_permission_set" "AWS-Billing-Administrator" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = "AWS-Billing-Administrator"
  depends_on   = [aws_ssoadmin_permission_set.AWS-Billing-Administrator]
}

# # AWS-Database-Administrator

# resource "aws_ssoadmin_permission_set" "AWS-Database-Administrator" {
#   description      = "AWS-Database-Administrator"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-Database-Administrator"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "Database" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-Database-Administrator.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
# }

# data "aws_ssoadmin_permission_set" "AWS-Database-Administrator" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-Database-Administrator"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-Database-Administrator]
# }
# # AWS-DataScientist

# resource "aws_ssoadmin_permission_set" "AWS-DataScientist" {
#   description      = "AWS-DataScientist"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-DataScientist"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "DataScientist" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-DataScientist.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/job-function/DataScientist"
# }

# data "aws_ssoadmin_permission_set" "AWS-DataScientist" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-DataScientist"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-DataScientist]
# }
# # AWS-NetworkAdministrator

# resource "aws_ssoadmin_permission_set" "AWS-NetworkAdministrator" {
#   description      = "AWS-NetworkAdministrator"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-NetworkAdministrator"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "NetworkAdministrator" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-NetworkAdministrator.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
# }

# data "aws_ssoadmin_permission_set" "AWS-NetworkAdministrator" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-NetworkAdministrator"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-NetworkAdministrator]
# }
# # AWS-PowerUserAccess

# resource "aws_ssoadmin_permission_set" "AWS-PowerUserAccess" {
#   description      = "AWS-PowerUserAccess"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-PowerUserAccess"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "PowerUserAccess" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-PowerUserAccess.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
# }

# data "aws_ssoadmin_permission_set" "AWS-PowerUserAccess" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-PowerUserAccess"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-PowerUserAccess]
# }
# # AWS-ReadOnlyAccess

# resource "aws_ssoadmin_permission_set" "AWS-ReadOnlyAccess" {
#   description      = "AWS-ReadOnlyAccess"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-ReadOnlyAccess"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "ReadOnlyAccess" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-ReadOnlyAccess.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }

# data "aws_ssoadmin_permission_set" "AWS-ReadOnlyAccess" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-ReadOnlyAccess"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-ReadOnlyAccess]
# }
# # AWS-SecurityAudit

# resource "aws_ssoadmin_permission_set" "AWS-SecurityAudit" {
#   description      = "AWS-SecurityAudit"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-SecurityAudit"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "SecurityAudit" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-SecurityAudit.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
# }

# data "aws_ssoadmin_permission_set" "AWS-SecurityAudit" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-SecurityAudit"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-SecurityAudit]
# }
# # AWS-SupportUser

# resource "aws_ssoadmin_permission_set" "AWS-SupportUser" {
#   description      = "AWS-SupportUser"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-SupportUser"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "SupportUser" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-SupportUser.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/job-function/SupportUser"
# }

# data "aws_ssoadmin_permission_set" "AWS-SupportUser" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-SupportUser"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-SupportUser]
# }
# # AWS-SystemAdministrator

# resource "aws_ssoadmin_permission_set" "AWS-SystemAdministrator" {
#   description      = "AWS-SystemAdministrator"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-SystemAdministrator"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "SystemAdministrator" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-SystemAdministrator.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
# }

# data "aws_ssoadmin_permission_set" "AWS-SystemAdministrator" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-SystemAdministrator"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-SystemAdministrator]
# }
# # AWS-ViewOnlyAccess

# resource "aws_ssoadmin_permission_set" "AWS-ViewOnlyAccess" {
#   description      = "AWS-ViewOnlyAccess"
#   instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name             = "AWS-ViewOnlyAccess"
#   session_duration = local.session_duration
#   tags             = local.common_tags
# }

# resource "aws_ssoadmin_managed_policy_attachment" "ViewOnlyAccess" {
#   instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   permission_set_arn = aws_ssoadmin_permission_set.AWS-ViewOnlyAccess.arn
#   managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
# }

# data "aws_ssoadmin_permission_set" "AWS-ViewOnlyAccess" {
#   instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
#   name         = "AWS-ViewOnlyAccess"
#   depends_on   = [aws_ssoadmin_permission_set.AWS-ViewOnlyAccess]
# }
