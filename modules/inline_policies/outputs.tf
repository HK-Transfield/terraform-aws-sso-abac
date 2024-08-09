output "arn" {
  description = "The Amazon Resource Number (ARN) of the custom permission set"
  value       = aws_ssoadmin_permission_set.this.arn
}

output "group_id" {
  description = "The group ID that has the custom permission set attached to it"
  value       = data.aws_identitystore_group.this.group_id
}