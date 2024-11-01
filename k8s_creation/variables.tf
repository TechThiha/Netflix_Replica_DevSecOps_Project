variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS Region"
}

variable "security_group_id" {
  type        = string
  description = "ID of the Security Group"
  default     = ""
}

variable "key_name" {
  type        = string
  description = "Name of the key pair"
}

variable "ami_id" {
  type        = string
  description = "Value of the AMI"
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
  description = "Path of the script file"
}

variable "instance_name" {
  type        = string
  description = "Name of the Instance"
}

variable "environment" {
  type        = string
  default     = "test"
  description = "The environment to deploy (test or prod)"
}