#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Install Ansible =========================\n"
rm -Rf ~/.ansible
git clone https://github.com/ansible/ansible.git ~/.ansible --recursive
cd ~/.ansible
source ./hacking/env-setup
sudo easy_install pip
sudo pip install -r ./requirements.txt
cd ~/
