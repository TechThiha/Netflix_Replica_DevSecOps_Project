variable "region" {
  type        = string
  description = "AWS Region"
}

variable "security_group_id" {
  type        = string
  description = "ID of the Security Group"
}

variable "key_name" {
  type        = string
  description = "Name of the key pair"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the instance"
}

variable "storage" {
  type        = number
  description = "Storage volume of EBS"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
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

variable "environment" {
  type        = string
  description = "Name of the Environment"
}