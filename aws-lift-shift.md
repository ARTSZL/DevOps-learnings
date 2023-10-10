# Web app setup with AWS cloud [Lift&Shift]

## Flow of execution
- Login to AWS Account
- Create Key Pairs
- Create Security Groups
- Launch Instances with user data
- Update IP to name mapping in Route53
- Build Application from source code
- Upload to S3 Bucket
- Download Artifact to Tomcat EC2 Instance
- Setup ELB (Elastic Load Balancer) with HTTPS
- Map ELB Endpoint to website name
- Verify
- Build Autoscaling Group for Tomcat Instances

## Steps
- In AWS console go to EC2
- Choose the region
- On left side find Key Pairs in Network & Security
- Create Key Pair using the orange button on the right top 'Create key pair'
- Add some short but descriptive name, choose the private key type and format, you can also add some tags
- After created the key pair go to security group
- Create Security Group using the orange button on the right top 'Create security group'
  - Security group for Load Balancer with inbound rule:
    - HTTPS, port: 443, source: Anywhere
  - Security group for Tomcat instance with inbound rules:
    - Custom TCP, port: 8080, source: security group of the Load Balancer
    - Custom TCP, port: 22, source: My IP (for SSH to instances)
    - Custom TCP, port: 8080, source: My IP (for acces directly from browser rather than from the Load Balancer)
  - Security group for backend services with inbound rules:
    - MySQL, port: 3306, source: application security group (for database)
    - Custom TCP, port: 11211, source: application security group (for memcache)
    - Custom TCP, port: 5672, source: application security group (for RabbitMQ)
    - All traffic, port: All, source: backend security group (allow internal traffic to flow on all ports)
    - Custom TCP, port: 22, source: My IP (for SSH to instances)
- 
