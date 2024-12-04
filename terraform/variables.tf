variable "aws_region" {
  type = string
  description = "Selected AWS Region"
}

variable "aws_profile" {
  type = string
  default = ""
  description = "AWS ROLE/USER to assume"
}

variable "project_name" {
  type = string
}

variable "account-id" {
  type = string
}

variable "notification_email" {
  type        = string
  description = "Email address for ASG notifications"
}