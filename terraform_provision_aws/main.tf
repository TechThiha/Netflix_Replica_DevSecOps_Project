locals {
  security_group_exists = length(data.aws_security_group.this) > 0
}

resource "aws_security_group" "default" {
  count       = local.security_group_exists ? 0 : 1
  name        = "Netflix_Henry"
  description = "Default security group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  root_block_device {
    volume_size = var.storage
    volume_type = var.volume_type
  }

  # User data for startup script
  user_data = file(var.file_path)

  # Security group
  vpc_security_group_ids = length(data.aws_security_group.this) > 0 ? [data.aws_security_group.this[0].id] : [aws_security_group.default[0].id]

  tags = {
    Name = "${var.instance_name}_${var.environment}_env"
  }
}
