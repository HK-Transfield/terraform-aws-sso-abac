# AWS Identity Center

## Usage
To run this example you need to execute:
```
terraform init
terraform plan -var="account_id=<YOUR_AWS_ACCOUNT_ID>"
terraform apply -var="account_id=<YOUR_AWS_ACCOUNT_ID>"
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.58.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_instance_access_control_attributes.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/ssoadmin_instance_access_control_attributes) | resource |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->