resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  root_block_device {
    volume_size = var.storage
    volume_type = var.volume_type
  }

  user_data = file(var.file_path)

  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = var.instance_name
  }
}

output "instance_public_ip" {
  value = aws_instance.this.public_ip
}
