# EC2 Instances Deployment with Custom VPC and Web Servers Setup using Terraform

This repository contains Terraform scripts to provision the AWS EC2 instances within a custom Virtual Private Cloud (VPC), a custom subnets, and set up a web servers. The configuration includes automatically assigning a public IP address to the instances.

## Prerequisites

Before you begin, ensure that you have the following prerequisites installed on your local machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)

Make sure you have your AWS credentials configured using the `aws configure` command.

## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/ARTSZL/devops-learnings.git

2. Change into the project directory:

   ```bash
   cd terraform-ec2-webserver

3. Initialize Terraform in the project directory:

   ```bash
   terraform init

4. Create a Terraform execution plan to view what resources will be created:

   ```bash
   terraform plan

5. Deploy the EC2 instance, VPC, subnet, and web server by applying the Terraform configuration:

   ```bash
   terraform apply

6. Confirm the deployment by typing yes when prompted.

## Accessing the EC2 Instance

7. Once the deployment is complete, Terraform will provide the public IP address and DNS of the EC2 instance in the output.

8. SSH into the EC2 instance using the provided public IP address and the private key associated with the key pair you specified in the Terraform configuration.

   ```bash
   ssh -i /path/to/private-key.pem ec2-user@public-ip

## Web Server Configuration

The web server is automatically set up on the EC2 instance during deployment. You can access the web server by opening a web browser and entering the public IP or DNS name provided by Terraform.

## Cleaning Up

To destroy all the AWS resources created by Terraform, use the following command:

   ```bash
   terraform destroy
   ```
Confirm the destruction by typing yes when prompted.

## Customization

You can customize the deployment by modifying the variables.tf file and other Terraform configuration files to adjust instance type, region, VPC/subnet settings, and more.
