## Outputs the access key ID and secret access key (shown after terraform apply)
output "lab_user_access_key_id" {
  value     = aws_iam_access_key.lab_user_key.id
  sensitive = false
}

output "lab_user_secret_access_key" {
  value     = aws_iam_access_key.lab_user_key.secret
  sensitive = true // Mark secret key as sensitive to avoid logging it by default
}

output "cross_account_role_arn" {
  description = "The ARN of the cross-account role."
  value       = aws_iam_role.veeam_for_aws_cross_account_role.arn
}

# output "db_endpoint" {
#   description = "The endpoint address of the RDS PostgreSQL instance"
#   value       = aws_db_instance.postgres_instance.endpoint
# }