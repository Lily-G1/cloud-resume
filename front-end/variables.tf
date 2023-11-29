variable "project_name" {
  type = string
  default = "cloud-resume-challenge"  
}

variable "domain_name" {
  type = string
  default = "liliangaladima.online"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "aws_credentials" {
  type        = string
  default     = "~/.aws/credentials2"
  description = "local path to AWS access credentials"
}
