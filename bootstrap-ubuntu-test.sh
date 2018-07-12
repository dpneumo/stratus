#!/usr/bin/env bash

# Keep in mind, this is running as the vagrant user, not root!

# Bring the box up to date
sudo apt-get -y update && sudo apt-get -y upgrade

# Install Ansible
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible

# Provide a sane ruby build environment
sudo apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
sudo apt-get -y install g++ # To compile therubyracer

# sqlite3 build requirement
sudo apt-get -y install libsqlite3-dev

# Fix git attributions and settings
git config --global user.name "Mitch Kuppinger"
git config --global user.email dpneumo@gmail.com
git config --global push.default simple

# Restore original keypair and set appropriate permissions
cp /vagrant/.ssh/id_rsa* ~/.ssh/
cp /vagrant/.ssh/known_hosts ~/.ssh/
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 644 ~/.ssh/known_hosts
chmod 644 ~/.ssh/authorized_keys

# Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src

# Install ruby-build as an rbenv plugin
mkdir -p plugins
cd plugins
git clone https://github.com/rbenv/ruby-build.git ruby-build

# Setup vagrant user to have access to rbenv on login
cat <<EOT >> ~/.profile

# rbenv
export PATH="~/.rbenv/bin:\$PATH"
eval "\$(rbenv init -)"

EOT
source ~/.profile

# Install a ruby c bundler
rbenv install 2.5.1
rbenv global 2.5.1
rbenv rehash
gem install bundler
