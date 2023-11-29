# Hosting a Resume with AWS S3, Cloudfront & Certificate Manager  
Hosting a static website on Amazon Web Services (AWS) can be a cost-effective and scalable solution for small to medium-sized websites.  
This repository contains terraform files that will quickly deploy a website on AWS S3, using AWS Cloudfront for global edge content delivery, Route53 for domain routing & provisions a free SSL certificate with AWS Certificate Manager  

## Pre-requisites:  
- An AWS account  
- Terraform installed  
- The folder 'site_files' should contain your website's source documents  
- In the *variables.tf* files, enter values of the following in their respective 'default' fields:  
  - AWS region  
  - Path to your stored AWS credentials (access & secret keys)  
  - Domain name  
  - Project name  
  - Environment name  
- In the *backend.tf* file, enter values of the following:  
  - Name of S3 state bucket  
  - Object key  
  - AWS region  
  - Path to your AWS access credentials (access & secret keys)  

## To run:  
1. Navigate into the *S3_bucket_state* subfolder and run:  
- $ terraform init  
- $ terraform plan  
- $ terraform apply  
2. Navigate back to main folder and run the same terraform commands to provision resources  