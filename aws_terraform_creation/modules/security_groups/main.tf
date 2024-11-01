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
