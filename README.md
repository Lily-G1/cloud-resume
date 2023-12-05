# cloud-resume  

![CRC drawio](https://github.com/Lily-G1/cloud-resume/assets/104821662/b83d7a25-a099-4cd2-9fa3-65775d7c84bc)  

My attempt at the infamous **Cloud Resume Project** where i host a static HTML/CSS/JS application using AWS serverless cloud infrastructure. The entire project is split into frontend & backend.  

The frontend is comprised of the web application files hosted on an S3 bucket, with content delivery by Cloudfront, SSL with Certificate Manager and Route53 for DNS hosting.  
The backend consists of a Lambda function that displays the app's total visitor count on the web page and stores same in a DynamoDB table. An API Gateway is included to provide a http URL that triggers the Lambda function.  

All these are provisioned using Terraform IAC and a Jenkins declarative pipeline is used for continous integration & delivery. Whenever new code is commited to this repo, the pipeline is auto triggered and deployed.  

![CRC #6 Console  Jenkins  - Brave 11_29_2023 8_11_31 PM](https://github.com/Lily-G1/cloud-resume/assets/104821662/3b91724e-7689-47ce-b558-1a695cf4da1f)  

![CRC #6 Console  Jenkins  - Brave 11_29_2023 8_18_35 PM](https://github.com/Lily-G1/cloud-resume/assets/104821662/54de4903-2e21-4be5-82cc-c8cc47860992)  
