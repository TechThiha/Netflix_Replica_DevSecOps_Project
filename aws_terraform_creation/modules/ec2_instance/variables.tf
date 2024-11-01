variable "ami_id" {
  type        = string
  description = "AMI ID for the instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "key_name" {
  type        = string
  description = "Name of the key pair"
}

variable "storage" {
  type        = number
  description = "Storage volume of EBS"
}

variable "volume_type" {
  type        = string
  description = "Volume type"
}

variable "file_path" {
  type        = string
  description = "Path of the user data file"
}

variable "instance_name" {
  type        = string
  description = "Name of the Instance"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the instance"
}
