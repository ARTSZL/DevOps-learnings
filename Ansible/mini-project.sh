#! /bin/bash
sudo apt update -y
sudo apt install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt update -y
sudo apt install ansible
sudo apt install python
sudo ex /etc/ansible/hosts <<EOEX
  :i
  [master]
  # master IP
  [slave]
  # slaves IP
  [master:vars]
  ansible_python_interpreter=/usr/bin/python3
  ansible_ssh_user=ubuntu
  ansible_ssh_private_key_file=/root/ # keypairfile
  [slave:vars]
  ansible_python_interpreter=/usr/bin/python3
  ansible_ssh_user=ubuntu
  ansible_ssh_private_key_file=/root/ # keypairfile
  .
  :x
EOEX
sudo ansible -m ping all
sudo mkdir /ansible
sudo cd /ansible
sudo ansible-playbook playbook.yml
sudo service apache2 status
