data "aws_ssoadmin_instances" "this" {} # need to grab the sso instance data

/*
SECTION 1: Define Custom Inline Policies
*/

module "sso_power_user" {
  source             = "./modules/inline_policies"
  inline_policy_name = "SSO-Power-User"
  project_tag_key    = "MyApp"
  project_tag_value  = var.project_tag

  conditional_actions = [
    "s3:GetObject",

    "s3:PutObject",
    "s3:DeleteObject",
    "s3:ListBucketMultipartUploads",
    "s3:AbortMultipartUpload",
    "s3:ListMultipartUploadParts"
  ]

  nonconditional_actions = [
    "s3:ListAllMyBuckets",
    "s3:ListBucket",
  ]
}

### Add Custom Inline Policies
module "terraformer_account_assignment" {
  source                 = "./modules/account_assignment"
  aws_account_identifier = "211125790048"

  aws_identitystore_groups = {
    (module.sso_power_user.group_id) = (module.sso_power_user.arn)
  }
}

/*
SECTION 2: Assign accounts
*/

### Add Managed policies
module "sandbox_account_assignment" {
  source                 = "./modules/account_assignment"
  aws_account_identifier = "339712731943"

  aws_identitystore_groups = {
    (data.aws_identitystore_group.AWS-Administrator.group_id)         = (data.aws_ssoadmin_permission_set.AWS-Administrator.arn)
    (data.aws_identitystore_group.AWS-Billing-Administrator.group_id) = (data.aws_ssoadmin_permission_set.AWS-Billing-Administrator.arn)
  }
}
