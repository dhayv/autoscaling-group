variable "autoscaling_group_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "autoscaling_policy_up_arn" {
  type = string
}

variable "autoscaling_policy_dwn_arn" {
  type = string
}

variable "account-id" {
  
}

variable "notification_email" {
  type        = string
  description = "Email address for ASG notifications"
}