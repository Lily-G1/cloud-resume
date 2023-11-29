# AWS credentials path
variable "credentials" {
  type        = string
  default     = "~/.aws/credentials2"
  description = "local path to stored AWS credentials"
}

# AWS region
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws region"
}

variable "aws_environment" {
  type        = string
  default     = "crc-dev"
  description = "aws_environment"
}


# # Domain name
# variable "domain" {
#   type        = string
#   default     = "liliangaladima.website"
#   description = "domain name"
# }

# # Sub-domain name
# variable "subdomain" {
#   type        = string
#   default     = "resume.liliangaladima.website"
#   description = "name of sub domain"
# }


