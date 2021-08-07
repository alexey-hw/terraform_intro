variable "namespace" {
  description = "Project name"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "ssh_keypair" {
  description = "SSH keypair to use for EC2 instance"
  default     = null
  type        = string
}

variable "my_ip_cidr" {
  description = "IP address which is used to grunt ssh access for bastion host"
  default     = "0.0.0.0/0"
  type        = string
}
