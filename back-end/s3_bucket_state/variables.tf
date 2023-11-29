variable "aws_credentials" {
  type        = string
  default     = "~/.aws/credentials2"
  description = "local path to stored aws credentials"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1" 
}

variable "state_bucket_BE" {
  type        = string
  default     = "backend-cloud-resume-challenge-state-files"
  description = "name of S3 bucket storing terraform state files"
}

