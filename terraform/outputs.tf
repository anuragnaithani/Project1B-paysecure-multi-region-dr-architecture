output "route53_health_check_id" {
  value = aws_route53_health_check.mumbai_api.id
}

output "primary_kms_key_arn" {
  value = aws_kms_key.paysecure_primary.arn
}

output "dr_kms_key_arn" {
  value = aws_kms_replica_key.paysecure_dr.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.idempotency.name
}
