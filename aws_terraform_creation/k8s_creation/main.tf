module "k8s_security_group" {
  source            = "../modules/security_groups"
  security_group_id = var.security_group_id
}

resource "aws_instance" "k8s_master" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  root_block_device {
    volume_size = var.storage
    volume_type = var.volume_type
  }

  user_data = file(var.master_user_data)

  vpc_security_group_ids = [
    length(module.k8s_security_group.existing_security_group_id) > 0
    ? module.k8s_security_group.existing_security_group_id
    : module.k8s_security_group.default_security_group_id
  ]

  tags = {
    Name = "${var.instance_name}_${var.environment}_master"
  }
}

resource "aws_instance" "k8s_worker" {
  count = 2 # Create two worker instances

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  root_block_device {
    volume_size = var.storage
    volume_type = var.volume_type
  }

  user_data = file(var.worker_user_data)

  vpc_security_group_ids = [
    length(module.k8s_security_group.existing_security_group_id) > 0
    ? module.k8s_security_group.existing_security_group_id
    : module.k8s_security_group.default_security_group_id
  ]

  tags = {
    Name = "${var.instance_name}_${var.environment}_worker_${count.index + 1}"
  }
}
