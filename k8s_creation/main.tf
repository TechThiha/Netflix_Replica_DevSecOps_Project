locals {
  security_group_exists = length(data.aws_security_group.this) > 0
}

resource "aws_security_group" "default" {
  count       = (length(data.aws_security_group.this) == 0) ? 1 : 0
  name        = "${var.instance_name}-${var.environment}-sg"
  description = "Security group for ${var.instance_name} in ${var.environment} environment"

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

  tags = {
    Name = "${var.instance_name}-${var.environment}-sg"
  }
}

resource "aws_instance" "master" {
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
    Name = "${var.instance_name}-Master"
  }
}

resource "aws_instance" "worker" {
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
    Name = "${var.instance_name}-Worker"
  }
}
