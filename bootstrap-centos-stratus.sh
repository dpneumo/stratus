#!/usr/bin/env bash

# Keep in mind, this is running as the vagrant user, not root!

# Bring the box up to date
sudo yum update -y

# Install EPEL
sudo yum install epel-release -y

# Development tools
sudo yum groups mark convert "Development Tools"
sudo yum group install -y "Development Tools"
sudo yum install -y gettext-devel perl-CPAN perl-devel zlib-devel nano expect tcl

# Install certbot (Let's Encrypt)
#sudo yum install certbot -y
sudo yum install python2-certbot-nginx -y

# Install nginx
sudo yum install nginx -y
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.$(date +%s)
sudo cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp /vagrant/nginx/cirrus.conf /etc/nginx/conf.d/cirrus.conf.443
sudo cp /vagrant/nginx/default.conf /etc/nginx/conf.d/default.conf
sudo chmod 644 /etc/nginx/nginx.conf
sudo chmod 644 /etc/nginx/conf.d/*
sudo systemctl enable nginx
sudo systemctl start nginx

# Install iptables
sudo yum install iptables-services -y
sudo cp /vagrant/iptables/rsyslog.conf /etc/rsyslog.d/20-iptables.conf
sudo chmod 644 /etc/rsyslog.d/20-iptables.conf
sudo cp /vagrant/iptables/logrotate.conf /etc/logrotate.d/iptables
sudo chmod 644 /etc/logrotate.d/iptables
sudo cp /vagrant/iptables/rules.sh iptables_rules.sh
sudo chmod 755 iptables_rules.sh
sudo touch /var/log/iptables_rules_install.log
sudo ./iptables_rules.sh >> /var/log/iptables_rules_install.log

# Swap firewalls
sudo systemctl stop firewalld
sudo systemctl start iptables
sudo systemctl disable firewalld
sudo systemctl enable iptables

# Install Fail2Ban
sudo yum install fail2ban -y
sudo cp /vagrant/fail2ban/jail.local /etc/fail2ban/
sudo cp /vagrant/fail2ban/jail.d/*.conf /etc/fail2ban/jail.d/
sudo cp /vagrant/fail2ban/filter.d/*.conf /etc/fail2ban/filter.d/
sudo chmod 644 /etc/fail2ban/jail.local
sudo chmod 644 /etc/fail2ban/jail.d/*
sudo chmod 644 /etc/fail2ban/filter.d/*
sudo rm /etc/fail2ban/jail.d/00-firewalld.conf
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Install Git
sudo yum install -y git

# Fix git attributions and settings
git config --global user.name "Mitch Kuppinger"
git config --global user.email dpneumo@gmail.com
git config --global push.default simple

# Restore original keypair and set appropriate permissions
#cp /vagrant/.ssh/id_rsa* ~/.ssh/
#cp /vagrant/.ssh/known_hosts ~/.ssh/
#chmod 600 ~/.ssh/id_rsa
#chmod 644 ~/.ssh/id_rsa.pub
#chmod 644 ~/.ssh/known_hosts
#chmod 644 ~/.ssh/authorized_keys


# Ansible -----------------------------
# Install Ansible
rm -Rf ~/.ansible
git clone https://github.com/ansible/ansible.git ~/.ansible --recursive
cd ~/.ansible
source ./hacking/env-setup
sudo easy_install pip
sudo pip install -r ./requirements.txt
cd ~/

# Ruby --------------------------------
# Provide a sane ruby build environment
sudo yum install -y bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel sqlite-devel

# Install rbenv
rm -Rf ~/.rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src

# Install ruby-build as an rbenv plugin
mkdir -p plugins
cd plugins
rm -Rf ~/.rbenv/plugins/ruby-build
git clone https://github.com/rbenv/ruby-build.git ruby-build
cd ~/

# Setup vagrant user to have access to rbenv on login
cat <<EOT >> ~/.bash_profile

# rbenv
export PATH="~/.rbenv/bin:\$PATH"
eval "\$(rbenv init -)"

EOT
source ~/.bash_profile

# Install a ruby & bundler
rbenv install 2.5.1
rbenv global 2.5.1
rbenv rehash
gem install bundler --no-document
