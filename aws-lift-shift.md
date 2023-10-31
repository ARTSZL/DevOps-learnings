# Web App Setup with AWS Cloud [Lift&Shift]

## Description

In this project, we will set up the Vprofile app created by VisualPath on the AWS cloud.

## Flow of Execution

1. Login to AWS Account
2. Create Key Pairs
3. Create Security Groups
4. Launch Instances with User Data
5. Update IP to Name Mapping in Route53
6. Build Application from Source Code
7. Upload to S3 Bucket
8. Download Artifact to Tomcat EC2 Instance
9. Setup ELB (Elastic Load Balancer) with HTTPS
10. Map ELB Endpoint to Website Name
11. Verify
12. Build Auto Scaling Group for Tomcat Instances

## Steps

### AWS Console Setup

1. In the AWS console, navigate to EC2.
2. Choose the desired region.
3. Create a Key Pair with a short but descriptive name, private key type, and format. Optionally, add tags.
4. After creating the key pair, go to Security Groups.

### Security Group Setup

Create Security Groups with the following inbound rules:

- Security group for Load Balancer:
  - Inbound rule for HTTPS (port 443) from "Anywhere."

- Security group for Tomcat instance:
  - Custom TCP rule for port 8080 from the security group of the Load Balancer.
  - Custom TCP rule for port 22 (SSH) from "My IP."
  - Custom TCP rule for port 8080 from "My IP" (for direct access from the browser).

- Security group for backend services:
  - MySQL (port 3306) from the application security group (for the database).
  - Custom TCP rule for port 11211 from the application security group (for Memcache).
  - Custom TCP rule for port 5672 from the application security group (for RabbitMQ).
  - Allow all traffic (port "All") from the backend security group (for internal traffic).
  - Custom TCP rule for port 22 (SSH) from "My IP."

### EC2 Instance Setup

1. Clone the repository: `https://github.com/hkhcoder/vprofile-project/tree/aws-LiftAndShift`.
2. Launch EC2 instances as follows:
   - `db01`: CentOS Stream 9, t3.micro, using the key pair and backend security group. In advanced details, copy and paste the `mysql.sh` entire script.
   - `mc01`: CentOS Stream 9, t3.micro, using the key pair and backend security group. In advanced details, copy and paste the `memcache.sh` entire script.
   - `rmq01`: CentOS Stream 9, t3.micro, using the key pair and backend security group. In advanced details, copy and paste the `rabbitmq.sh` entire script.
   - `app01`: Ubuntu Server 22.04 LTS, t3.micro, using the key pair and application security group. In advanced details, copy and paste the `tomcat_ubuntu.sh` entire script.

### Route53 Setup

1. Create a hosted zone in Route53 with the type "Private," using the same region as the instances.
2. Create the following simple records:
   - `db01.[hosted zone name]` with the private IP of `db01` instance.
   - `mc01.[hosted zone name]` with the private IP of `mc01` instance.
   - `rmq01.[hosted zone name]` with the private IP of `rmq01` instance.

### Application Configuration

1. Update the application configuration in the `../src/main/resources/application.properties` file:
   - Change the database URL to: `jdbc.url=jdbc:mysql://db01.[hosted zone name]:3306/accounts?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull`.
   - Set `memcache.active.host` to `mc01.[hosted zone name]`.
   - Set `rabbitmq.address` to `rmq01.[hosted zone name]`.

2. Save the changes and navigate to the directory containing the `pom.xml` file.

### Artifact Build and Deployment

1. Install JDK 11, Maven 3, and AWS CLI.
2. Build the artifact using the `mvn install` command in the terminal.

### AWS Configuration

1. Create a new IAM user with attached policies, including "AmazonS3FullAccess."
2. After creating the user, go to the user's Security Credentials.
3. Create an access key with Command Line Interface (CLI) and download the access key file.
4. Use `aws configure` in the terminal to configure the AWS CLI with the public and private passwords, choose the region, and set the file format.

### S3 Bucket and Artifact Upload

1. Create an S3 bucket using `aws s3 mb s3://[unique bucket name]`.
2. Copy the artifact to the S3 bucket using `aws s3 cp target/vprofile-v2.war s3://[unique bucket name]`.

### IAM Role Configuration

1. Create an IAM role for EC2 instances with the "AmazonS3FullAccess" policy attached.
2. Update the IAM role for the application EC2 instance.

### Artifact Deployment

1. SSH to the application instance using `ssh -i [key pair directory] ubuntu@[application public IP address]`.
2. Switch to the ROOT user with `sudo -i`.
3. Copy the artifact from the S3 bucket to the EC2 instance using `aws s3 cp s3://[unique bucket name] /tmp/`.
4. Stop Tomcat with `systemctl stop tomcat9`.
5. Remove the default application: `rm -rf /var/lib/tomcat9/webapps/ROOT`.
6. Copy the artifact: `cp /tmp/ /var/lib/tomcat9/webapps/ROOT.war`.
7. Start Tomcat with `systemctl start tomcat9`.

### Load Balancer Setup

1. Create a Target Group with type "Instances," protocol "HTTP," port "8080," and a health check path of "/login."
2. Use the health check on the Elastic Load Balancer (ELB).

### DNS Mapping and Verification

1. Map the Elastic Load Balancer endpoint to the domain name in your domain provider by adding a CNAME record.
2. To verify, go to your browser and enter the DNS record (e.g., `https://[CNAME].[domain name]`).

### Auto Scaling Group Setup

1. Create an Amazon Machine Image (AMI) from the `app01` instance.
2. Create a Launch Configuration using the AMI and configure it.
3. Create an Auto Scaling Group with the Launch Configuration, select all the subnets, and configure auto scaling policies.

### Instance Cleanup

You can now terminate the `app01` instance if desired.

### Validation

- Access your application using the DNS record.
- Log in using "admin_vp" for login and password.
- Check RabbitMQ by clicking the RabbitMQ button.
- Verify Memcache by visiting the user details page.

## Congratulations!

You've successfully set up the Vprofile app on the AWS cloud with a Lift&Shift approach.
