# Ansible Apache Installation Project

This Ansible project automates the installation of the Apache web server on two slave instances. It also creates a simple `index.html` page that can be accessed via a web browser.

## Prerequisites

Before running this Ansible project, make sure you have the following prerequisites in place:

- Ansible installed on your control machine.
- Access to two slave instances (Linux-based) where you want to install Apache.
- SSH access to the slave instances with the necessary permissions.

## Usage

1. Clone this project to your control machine:

   ```bash
   git clone https://github.com/ARTSZL/devops-learnings.git

2. Navigate to the project directory:

   ```bash
   cd /devops-learnings/Ansible
   ```
3. Update the Ansible inventory file (inventory.ini) to include the IP addresses or hostnames of your slave instances. You should have two entries, one for each slave.

   ```ini
   [web-servers]
   slave1 ansible_host=<slave1-ip-or-hostname>
   slave2 ansible_host=<slave2-ip-or-hostname>

4. Review and customize the Apache installation playbook (playbook.yml) if necessary. This playbook uses the apt package manager, suitable for Debian-based systems. If you're using a different package manager, modify the playbook accordingly.

   ```yaml
   ---
   - name: Install Apache web server
     hosts: web-servers
     tasks:
       - name: Update apt package cache
         apt:
           update_cache: yes

       - name: Install Apache
         apt:
           name: apache2
           state: present

       - name: Start Apache service
         service:
           name: apache2
           state: started
           enabled: yes

5. Run the Ansible playbook to install Apache and create the index.html page:

   ```bash
   ansible-playbook -i inventory.ini playbook.yml

6. Once the playbook execution is complete, you can access the Apache web server on both slave instances by opening a web browser and entering their IP addresses or hostnames.

- Slave 1: http://[slave1-ip-or-hostname]
- Slave 2: http://[slave2-ip-or-hostname]

7. You should see a simple "Hello, Ansible!" message on the default Apache index.html page.

## Customization

You can customize the Apache installation, web page content, and other aspects of this project by modifying the Ansible playbook and roles to suit your specific requirements.

## Acknowledgments

This project was inspired by the need for a simple Apache installation and configuration automation using Ansible.
Feel free to contribute to or enhance this project as needed.
