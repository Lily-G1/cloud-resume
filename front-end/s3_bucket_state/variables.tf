variable "aws_credentials" {
  type        = string
  default     = "~/.aws/credentials2"
  description = "local path to stored aws credentials"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1" # ACM must be in US-East-1 region, hence the change in region
}

variable "state_bucket" {
  type        = string
  default     = "frontend-cloud-resume-challenge-state-files"
  description = "name of S3 bucket storing terraform state files"
}

