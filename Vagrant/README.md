# Vagrant Local Setup for V-profile App

This project provides a local setup environment for the V-profile app. You can quickly create a local development environment using Vagrant and test the V-profile app.

## Prerequisites

Before getting started, ensure you have the following software installed on your system:

- VirtualBox, VMware, or another provider (Vagrant supports multiple providers)
- Vagrant
- Terminal, PowerShell, or another command-line interface
- Git

## Getting Started

Follow these steps to set up the local environment:

1. Open your terminal or command-line interface.

2. Create a directory to house your Vagrant project. You can choose a suitable name for the directory.

3. Navigate to the directory you created in the previous step.

4. Clone the V-profile app code from GitHub to the directory using the following command:

   ```shell
   git clone https://github.com/devopshydclub/vprofile-project/tree/local-setup/
   
5. Open the directory containing the Vagrantfile. This file specifies the Vagrant configuration.

6. Use the following command to start the virtual machines (VMs) defined in the Vagrantfile:

   ```shell
   vagrant up
   ```
Vagrant will provision the VMs according to the configuration provided.

7. Once all the VMs are up and running, you can access the V-profile app by entering the NginX IP address or hostname from the Vagrantfile in your web browser.

8. For login purposes, use the following credentials:

- Username: admin_vp
- Password: admin_vp

9. To check the RabbitMQ, click the 'RabbitMQ' button within the app.

10. To check the Memcache functionality, follow these steps:

- Click the 'All Users' button within the app.
- Choose one user from the list.
- Go back to the previous screen.
- Click on the same user again. If the data is retrieved from the cache, you should see a message at the top of the page indicating that the data is from the cache.

## Congratulations!

You have successfully set up the V-profile app in a local development environment using Vagrant. You can now test and explore the app locally.
