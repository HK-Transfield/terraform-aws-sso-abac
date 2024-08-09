/*
Retrieves the AD groups and assigns them data sources

List of Groups:
  AWS-Billing-Administrator
  AWS-Database-Administrator
  AWS-DataScientist
  AWS-NetworkAdministrator
  AWS-PowerUserAccess
  AWS-ReadOnlyAccess
  AWS-SecurityAudit
  AWS-SupportUser
  AWS-SystemAdministrator
  AWS-ViewOnlyAccess
*/

data "aws_identitystore_group" "AWS-Administrator" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AWS-Administrator"
    }
  }
}

data "aws_identitystore_group" "AWS-Billing-Administrator" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AWS-Billing-Administrator"
    }
  }
}

# data "aws_identitystore_group" "AWS-Database-Administrator" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-Database-Administrator"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-DataScientist" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-DataScientist"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-NetworkAdministrator" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-NetworkAdministrator"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-PowerUserAccess" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-PowerUserAccess"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-ReadOnlyAccess" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-ReadOnlyAccess"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-SecurityAudit" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-SecurityAudit"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-SupportUser" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-SupportUser"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-SystemAdministrator" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-SystemAdministrator"
#     }
#   }
# }

# data "aws_identitystore_group" "AWS-ViewOnlyAccess" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "DisplayName"
#       attribute_value = "AWS-ViewOnlyAccess"
#     }
#   }
# }