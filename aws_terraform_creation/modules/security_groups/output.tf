output "existing_security_group_id" {
  value = local.security_group_exists ? data.aws_security_group.this[0].id : ""
}

output "default_security_group_id" {
  value = local.security_group_exists ? "" : aws_security_group.default[0].id
}
