output "sso_instance_arn" {
  value = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}