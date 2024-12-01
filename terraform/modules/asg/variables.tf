variable "project_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "launch_template_id" {
  type = string
}

variable "launch_template_version" {
  type = string
}

variable "azs" {
  type = list(string)
  description = "availabilty zones"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}