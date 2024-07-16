data "aws_ssoadmin_instances" "my_sso_instances" {}

# Admin Group
data "aws_identitystore_group" "AWS-Administrator" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.my_sso_instances.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AWS-Administrator"
    }
  }
}

data "aws_identitystore_group" "AWS-Database-Administrator" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.my_sso_instances.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AWS-Database-Administrator"
    }
  }
}

# Make a few accounts in the AWS IAM Identity Center, put them in groups, see if I can assign permission sets to them.
# Following groups for testing
# Billing Admin

# Database Admin

# DataScientist

# Following groups to test once the above work
# Network Administrator
# Power User Access
# Read Only Access
# Security Audit
# Support User
# System Administrator
# View Only Access

