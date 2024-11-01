output "existing_security_group_id" {
  value = length(data.aws_security_group.this) > 0 ? data.aws_security_group.this[0].id : "No existing security group found"
}

output "instance_public_ip" {
  value       = aws_instance.this.public_ip
  description = "The public IP address of the EC2 instance"
}