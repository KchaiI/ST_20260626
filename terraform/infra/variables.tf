variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  type    = string
  default = "project"
}

variable "environment" {
  type    = string
  default = "dev"
}