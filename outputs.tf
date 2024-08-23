output "principal_id" {
  description = "The principal ID that has the custom permission set attached to it"
  value       = local.principal_id
}

output "permission_set_arn" {
  description = "The Amazon Resource Number (ARN) of the custom permission set"
  value       = aws_ssoadmin_permission_set.this.arn
}

output "permission_set_created_date" {
  description = "The date the Permission Set was created in RFC3339 format"
  value       = data.aws_ssoadmin_permission_set.this.created_date
}

output "account_assignment" {
  description = "All account assignments made"
  value       = aws_ssoadmin_account_assignment.this
}