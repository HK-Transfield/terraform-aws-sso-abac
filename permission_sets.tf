##### AWS Administrator

resource "aws_ssoadmin_permission_set" "AWS-Administrator" {
  description = "AWS-Administrator"
  # Previously changed from var.sso_instance_arn
  instance_arn     = data.aws_ssoadmin_instances.my_sso_instances.arns[0] # Retrieves the first instance of an AWS IAM Identity Center in my account. There can be multiple identity centers.
  name             = "AWS-Administrator"
  session_duration = var.session_time
  tags             = { "Source" = "Implemented via Terraform - mgmt accnt" }
}

resource "aws_ssoadmin_managed_policy_attachment" "AWS-Administrator" {
  instance_arn       = data.aws_ssoadmin_instances.my_sso_instances.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.AWS-Administrator.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Turn the "AdministratorAccess" part into a variable. Possibly using Python
}

# This data block might be unnecessary
data "aws_ssoadmin_permission_set" "AWS-Administrator" {
  instance_arn = data.aws_ssoadmin_instances.my_sso_instances.arns[0]
  name         = "AWS-Administrator"
  depends_on   = [aws_ssoadmin_permission_set.AWS-Administrator]
}

##### AWS Database Administrator

resource "aws_ssoadmin_permission_set" "AWS-Database-Administrator" {
  description      = "AWS-Database-Administrator"
  instance_arn     = data.aws_ssoadmin_instances.my_sso_instances.arns[0]
  name             = "AWS-Database-Administrator"
  session_duration = var.session_time
  tags             = { "Source" = "Implemented via Terraform - mgmt accnt" }
}

resource "aws_ssoadmin_managed_policy_attachment" "Database" {
  instance_arn       = data.aws_ssoadmin_instances.my_sso_instances.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.AWS-Database-Administrator.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

data "aws_ssoadmin_permission_set" "AWS-Database-Administrator" {
  instance_arn = data.aws_ssoadmin_instances.my_sso_instances.arns[0]
  name         = "AWS-Database-Administrator"
  depends_on   = [aws_ssoadmin_permission_set.AWS-Database-Administrator]
}