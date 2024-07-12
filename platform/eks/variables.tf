variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "name" {
  default = "eks-training"
}

variable "profile" {
  default = "devops"
}
