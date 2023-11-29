# Store state file in S3 bucket
terraform {
  backend "s3" {
    bucket                  = "backend-cloud-resume-challenge-state-files"
    region                  = "us-east-1"
    key                     = "cloud-resume-challenge/terraform.tfstate"
    shared_credentials_file = "~/.aws/credentials2"
  }
}
