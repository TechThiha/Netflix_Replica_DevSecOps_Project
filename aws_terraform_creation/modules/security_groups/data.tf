data "aws_security_group" "this" {
  count = var.security_group_id != "" ? 1 : 0
  id    = var.security_group_id
}