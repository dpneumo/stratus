#!/usr/bin/env bash

# Keep in mind, this is running as the vagrant user, not root!

# Bring the box up to date
sudo yum clean all
sudo rm -rf /var/cache/yum/*
sudo yum update -y

# Install EPEL
sudo yum install epel-release -y

printf "========= Install Development tools ===============\n"
# Development tools
sudo yum groups mark convert "Development Tools"
sudo yum group install -y "Development Tools"
sudo yum install -y gettext-devel perl-CPAN perl-devel zlib-devel nano expect tcl

printf "========= Install certbot (Let's Encrypt) =========\n"
# Install certbot (Let's Encrypt)
#sudo yum install certbot -y
sudo yum install python2-certbot-nginx -y

printf "========= Install nginx ===========================\n"
sudo yum install nginx -y
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.$(date +%s)
sudo cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp /vagrant/nginx/stratus.conf /etc/nginx/conf.d/stratus.conf
sudo cp /vagrant/nginx/stratus.conf /etc/nginx/conf.d/stratus.conf.443
sudo cp /vagrant/nginx/default.conf /etc/nginx/conf.d/default.conf.80
sudo chmod 644 /etc/nginx/nginx.conf
sudo chmod 644 /etc/nginx/conf.d/*
sudo touch /var/log/nginx/error.log
sudo touch /var/log/nginx/access.log
sudo systemctl enable nginx
# Do not start nginx yet. Need certs for TLS in place first.

printf "========= Permanently stop firewalld ==============\n"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask firewalld

printf "========= Setup iptables logging ==================\n\n"
sudo touch /var/log/iptables.log
sudo chmod 666 /var/log/iptables.log
sudo cp /vagrant/iptables/rsyslog.conf /etc/rsyslog.d/20-iptables.conf
sudo chmod 644 /etc/rsyslog.d/20-iptables.conf
sudo systemctl restart rsyslog
sudo cp /vagrant/iptables/logrotate.conf /etc/logrotate.d/iptables
sudo chmod 644 /etc/logrotate.d/iptables

printf "========= Install iptables ========================\n"
sudo yum install iptables-services -y
sudo systemctl start iptables
sudo systemctl enable iptables
sudo cp /vagrant/iptables/rules.sh iptables_rules.sh
sudo chmod 755 iptables_rules.sh
sudo touch /var/log/iptables_rules_install.log
sudo chmod 666 /var/log/iptables_rules_install.log
# ***** Install new iptables rules *****
sudo ./iptables_rules.sh >> /var/log/iptables_rules_install.log

printf "========= Install Fail2Ban ========================\n"
sudo yum --enablerepo=epel clean metadata
sudo yum install fail2ban -y
sudo cp /vagrant/fail2ban/jail.local /etc/fail2ban/
sudo cp /vagrant/fail2ban/jail.d/*.conf /etc/fail2ban/jail.d/
sudo cp /vagrant/fail2ban/filter.d/*.conf /etc/fail2ban/filter.d/
sudo chmod 644 /etc/fail2ban/jail.local
sudo chmod 644 /etc/fail2ban/jail.d/*
sudo chmod 644 /etc/fail2ban/filter.d/*
if [[ -e /etc/fail2ban/00-firewalld.conf ]]; then
  sudo rm /etc/fail2ban/jail.d/00-firewalld.conf
fi
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

printf "========= Install Git =============================\n"
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

printf "========= Install OpenSSL =========================\n"
sudo yum install openssl -y
cp /vagrant/openssl/setup_ca.sh setup_ca.sh
chmod +x setup_ca.sh

printf "========= Install Ansible =========================\n"
rm -Rf ~/.ansible
git clone https://github.com/ansible/ansible.git ~/.ansible --recursive
cd ~/.ansible
source ./hacking/env-setup
sudo easy_install pip
sudo pip install -r ./requirements.txt
cd ~/

printf "========= Install ruby build environment ==========\n"
sudo yum install -y bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel sqlite-devel

printf "========= Install rbenv ===========================\n"
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

printf "========= Install a ruby & bundler ================\n"
rbenv install 2.5.1
rbenv global 2.5.1
rbenv rehash
gem install bundler --no-document

printf "========= Manual tasks that must be done ==========\n"
read -r -d '' REMAINING_TASKS <<EOT
***************************************
Remaining Manual tasks:
From the host: vagrant ssh

1. Run setup_ca.sh from /home/vagrant on vm

2. cd cirrus

3. Init app:
    a. bundle install
    b. bundle exec rails db:migrate

4. Start rails: 'bundle exec rails server'

5. Copy certificates contained
   in CA/cacert.pem & CA/certs/stratus.pem
   to cirrus/config/credentials.yml.enc

   Use: 'EDITOR=nano bundle exec rails credentials:edit'
   Notice the indent used for the certificate text

6. Start nginx: 'sudo systemctl start nginx'
EOT

echo "$REMAINING_TASKS"
