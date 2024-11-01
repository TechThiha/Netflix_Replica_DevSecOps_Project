module "security_group" {
  source            = "../modules/security_groups"
  security_group_id = var.security_group_id
}


module "ec2_instance" {
  source        = "../modules/ec2_instance"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  storage       = var.storage
  volume_type   = var.volume_type
  file_path     = var.file_path
  instance_name = "${var.instance_name}_${var.environment}_env"
  security_group_ids = [
    length(module.security_group.existing_security_group_id) > 0
    ? module.security_group.existing_security_group_id
    : module.security_group.default_security_group_id
  ]
}