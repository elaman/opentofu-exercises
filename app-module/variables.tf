variable "app_name" {
  description = "Application name"
  type        = string
  default     = "app"
}

variable "compute_ami" {
  description = "Amazon machine image for compute instance"
  type        = string
  default     = "ami-04075458d3b9f6a5b"
}

variable "compute_instance_type" {
  description = "Compute instance type"
  type        = string
  default     = "t2.micro"
}

variable "dns_create_zone" {
  description = "If true, create new route53 zone, if false read existing route53 zone"
  type        = bool
  default     = false
}

variable "dns_domain" {
  description = "Domain for website"
  type        = string
}

variable "db_name" {
  description = "DB name"
  type        = string
}

variable "db_user" {
  description = "DB username"
  type        = string
}

variable "db_pass" {
  description = "DB password"
  type        = string
  sensitive   = true
}