variable "project_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}


variable "alb_security_groups_id" {
  type = string
}

