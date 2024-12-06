
# AWS Auto Scaling Infrastructure Project

This project demonstrates a highly available auto-scaling infrastructure using AWS and Terraform.

## Table of Contents
- [Project Overview](#project-overview)
  - [Features](#features)
- [Real-World Use Cases](#real-world-use-cases)
- [Benefits](#benefits)
- [Technologies Used](#technologies-used)
- [Infrastructure Overview](#infrastructure-overview)
- [Setup and Installation](#setup-and-installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)

## Project Overview

This project demonstrates the implementation of an autoscaling web server infrastructure using Amazon Web Services (AWS), Terraform, and Nginx. The primary goal is to create a scalable, reliable, and cost-efficient web server setup that can handle varying traffic loads automatically. This infrastructure is ideal for businesses that experience fluctuating website traffic, such as during marketing campaigns or product launches.

### Features
- **Auto Scaling:** Dynamic EC2 instance adjustment based on CPU utilization
- **High Availability:** Multi-AZ deployment across 3 availability zones
- **Security First:** Private subnet deployment with NAT Gateway
- **Load Balancing:** Application Load Balancer with health checks
- **Infrastructure as Code:** Complete Terraform configuration
- **Monitoring:** CloudWatch alarms with SNS notifications

## Real-World Use Cases
1. **E-commerce Websites:** Handle varying traffic during sales events, holidays, or product launches without compromising performance.
2. **Content Delivery Platforms:** Scale resources based on user engagement and content consumption patterns.
3. **SaaS Applications:** Manage fluctuating user loads efficiently, ensuring high availability and responsiveness.
4. **Media Streaming Services:** Adjust infrastructure to accommodate changes in viewership and streaming demands.

## Benefits
- **Scalability:** Automatically adjust resources to meet demand, ensuring optimal performance.
- **Cost Efficiency:** Pay only for the resources you use by scaling down during low traffic periods.
- **Reliability:** Distribute traffic across multiple instances to prevent single points of failure.
- **Security:** Enhance infrastructure security by isolating web servers in private subnets.
- **Hands-On Experience:** Gain practical skills in cloud infrastructure management, Terraform, and Nginx configuration.

## Technologies Used
- **AWS (Amazon Web Services):** Core cloud platform for deploying and managing infrastructure.
- **Terraform:** Infrastructure as Code (IaC) tool for automating the provisioning of AWS resources.
- **Nginx:** High-performance web server for handling HTTP requests.
- **Python:** Scripting and automation within the infrastructure setup.
- **AWS CloudWatch:** Monitoring service for observing resource utilization and setting alarms.

## Setup and Installation
1. Clone the Repository
```bash
git clone https://github.com/yourusername/aws-autoscaling-group.git
cd aws-autoscaling-group
cd terraform
```
2. Configure AWS Credentials
Ensure your AWS credentials are set up. You can configure them using the AWS CLI:
```bash
aws configure
```
Provide your AWS Access Key ID, Secret Access Key, region, and output format when prompted.

3. Initialize Terraform
Initialize Terraform to download the necessary providers and set up the project.

```bash
terraform init
```
4. Deploy the Infrastructure
Review the Terraform plan to see the resources that will be created.

```bash
terraform plan
```
Apply the Terraform configuration to create the infrastructure.

```bash
terraform apply
```
Type yes when prompted to confirm the deployment.

## Project Structure

terraform/
├── modules/
    ├── alb/          # Application Load Balancer configuration
    ├── asg/          # Auto Scaling Group settings
    ├── monitoring/   # CloudWatch and SNS setup
    ├── vpc/          # Network infrastructure
    └── launch-template/ # EC2 instance configuration
├── scripts/
    └── ec2.sh       # Instance setup script
├── main.tf          # Main configuration
├── outputs.tf       # Output definitions
└── variables.tf     # Variable declarations

- **main.tf:** Core Terraform configuration file defining AWS resources.
- **variables.tf:** Variable definitions for Terraform configurations.
- **outputs.tf:** Outputs from Terraform after deployment.
- **scripts/ec2.sh:** User data script to configure Nginx on EC2 instances.
- **README.md:** Project documentation.

## Usage
Once the infrastructure is deployed:
1. **Access the Website:**
- Retrieve the DNS name of the Application Load Balancer (ALB) from the Terraform outputs.
- Open a web browser and navigate to the ALB DNS to access the Nginx web server.
2. **Simulate Traffic:**
- To test autoscaling, simulate traffic spikes using tools like Apache JMeter or by manually generating requests.
- Monitor the scaling activities via the AWS Management Console under the EC2 Autoscaling Groups section or through CloudWatch metrics.

3. **Monitor Performance:**
  - Use AWS CloudWatch to observe CPU utilization and other relevant metrics.
  - nsure that the autoscaling policies are triggering as expected based on the defined thresholds.

## Security Considerations
- Web servers in private subnets
- Restricted security groups
- Least privilege IAM 
- No direct internet access to instances


## Troubleshooting

### Common Issues

1. 502 Bad Gateway
- Verify security group configurations
- Check target group health checks
- Ensure Nginx is running on instances

2. Failed Deployments
- Validate AWS credentials
- Check VPC endpoint connectivity
- Review CloudWatch logs

### Cost Considerations

- EC2 instances (t2.micro) in private subnets
- NAT Gateway hourly charges
- ALB running costs
- CloudWatch monitoring fees

