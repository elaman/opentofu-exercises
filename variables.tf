variable "region" {
  description = "Project region"
  type = string
}

variable "domain" {
  description = "Name of the project"
  type = string
}

variable "ami" {
  description = "Amazon image to use for EC2 instances"
  type = string
}

variable "instance_type" {
  description = "Type of the instance"
  type = string
}

variable "db_name" {
  description = "Database name"
  type = string
}

variable "db_user" {
  description = "Database username"
  sensitive = true
}

variable "db_pass" {
  description = "Database password"
  type = string
  sensitive = true
}
