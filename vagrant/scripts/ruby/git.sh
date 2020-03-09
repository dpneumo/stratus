#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Install Git =============================\n"
ver="$(git --version 2>&1)"
if [[ $ver != 'git version *' ]]; then
  sudo yum install -y git
fi
git config --global user.name  $GitUserName
git config --global user.email $GitUserEmail
git config --global push.default simple
