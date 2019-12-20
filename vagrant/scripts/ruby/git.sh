#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Install Git =============================\n"
sudo yum install -y git
git config --global user.name  $GitUserName
git config --global user.email $GitUserEmail
git config --global push.default simple
