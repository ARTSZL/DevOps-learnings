# Local setup for V-profile app from https://github.com/devopshydclub/vprofile-project/tree/local-setup/

## Prerequisites
- VirtualBox, VMware or another provider
- Vagrant
- Terminal, PowerShell or another
- Git

## Steps
- Open the terminal and create directory
- Go to that directory
- Clone the code from GitHub to that directory
- Open directory with Vagrantfile
- Use vagrant up to start the VMs
- When all the VMs are up You can test the app using the NginX IP or host name from Vagrantfile and pasted it to the browser
- Login and password are 'admin_vp'
- To check the RabbitMQ click the 'RabbitMQ' button
- To check the Memcache click button 'All Users', use one user and click it, use back button and again go to that user (On top of the page should be info [Data is From Cache]) 
