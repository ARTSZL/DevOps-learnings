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
