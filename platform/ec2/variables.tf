variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "name" {
  default = "ec2-training"
}

variable "profile" {
  default = "devops"
}

variable "ami" {
  default = "ami-060e277c0d4cce553"
}

variable "instance_type" {
  default = "t2.small"
}

variable "key_name" {
  default = "devops"
}