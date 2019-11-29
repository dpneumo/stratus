#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Keep in mind, this is running as the vagrant user, not root!

# Bring the box up to date
sudo yum clean all
sudo rm -rf /var/cache/yum/*
sudo yum install deltarpm -y
sudo yum install https://centos7.iuscommunity.org/ius-release.rpm -y
sudo yum install epel-release -y
sudo yum update -y

printf "========= Install Development tools ===============\n"
sudo yum groups mark convert "Development Tools"
sudo yum group install "Development Tools" -y
sudo yum install gettext-devel perl-CPAN perl-devel zlib-devel nano expect tcl -y

printf "========= Install Python 3.6 ===================\n"
sudo yum install python36u python36u-libs python36u-devel python36u-pip -y
python3.6 -V

printf "========= Stop & disable rpcbind ===============\n"
sudo systemctl stop rpcbind
sudo systemctl stop rpcbind.socket
sudo systemctl disable rpcbind

printf "========= Setup iptables logging ==================\n\n"
sudo touch /var/log/iptables.log
sudo cp $SRC/iptables/rsyslog.conf   /etc/rsyslog.d/20-iptables.conf
sudo cp $SRC/iptables/logrotate.conf /etc/logrotate.d/iptables/
sudo chmod 666 /var/log/iptables.log
sudo chmod 644 /etc/rsyslog.d/20-iptables.conf
sudo chmod 644 /etc/logrotate.d/iptables
sudo systemctl restart rsyslog

printf "========= Install iptables and rules ================\n"
sudo yum install iptables-services -y
sudo cp $SRC/iptables/rules.sh iptables_rules.sh
sudo touch /var/log/iptables_rules_install.log
sudo chmod 755 iptables_rules.sh
sudo chmod 666 /var/log/iptables_rules_install.log
sudo ./iptables_rules.sh >> /var/log/iptables_rules_install.log

printf "========= Stop firewalld & Start iptables============\n"
sudo systemctl stop firewalld
sudo systemctl start iptables
sudo systemctl enable iptables
sudo systemctl disable firewalld
sudo systemctl mask firewalld

printf "========= Install Git =============================\n"
sudo yum install -y git
git config --global user.name "Mitch Kuppinger"
git config --global user.email dpneumo@gmail.com
git config --global push.default simple

printf "========= Install Fail2Ban ==========================\n"
git clone https://github.com/fail2ban/fail2ban.git
sudo python setup.py install
sudo cp $SRC/fail2ban/fail2ban.local   /etc/fail2ban/
sudo cp $SRC/fail2ban/jail.local       /etc/fail2ban/
sudo cp $SRC/fail2ban/jail.d/*.local   /etc/fail2ban/jail.d/
sudo cp $SRC/fail2ban/filter.d/*.local /etc/fail2ban/filter.d/
sudo cp $SRC/fail2ban/gen_badbots      /etc/fail2ban/gen_badbots
if [[ -e /etc/fail2ban/00-firewalld.conf ]]; then
  sudo rm /etc/fail2ban/jail.d/00-firewalld.conf
fi
sudo chmod 644 /etc/fail2ban/fail2ban.local
sudo chmod 644 /etc/fail2ban/jail.local
sudo chmod 644 /etc/fail2ban/jail.d/*
sudo chmod 644 /etc/fail2ban/filter.d/*
sudo chmod 755 /etc/fail2ban/gen_badbots
sudo /etc/fail2ban/gen_badbots
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

printf "========= ssh files ===============================\n"
# See https://stribika.github.io/2015/01/04/secure-secure-shell.html
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sudo mv /etc/ssh/sshd_config       /etc/ssh/sshd_config.$(date +%s)
sudo mv /etc/ssh/ssh_config        /etc/ssh/ssh_config.$(date +%s)
sudo cp /etc/ssh/moduli /etc/ssh/moduli.$(date +%s)
sudo awk '$5 > 2000' /etc/ssh/moduli > "${HOME}/moduli"
sudo mv "${HOME}/moduli" /etc/ssh/moduli
sudo cp $SRC/ssh/sshd_config       /etc/ssh/
sudo cp $SRC/ssh/ssh_config        /etc/ssh/
touch ~/.ssh/known_hosts
touch ~/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/id_rsa      /etc/ssh/sshd_config
sudo chmod 644 ~/.ssh/id_rsa.pub ~/.ssh/known_hosts ~/.ssh/authorized_keys

printf "========= Install certbot (Let's Encrypt) =========\n"
# Install certbot (Let's Encrypt)
#sudo yum install certbot -y
sudo yum install python2-certbot-nginx -y

printf "========= Install nginx ===========================\n"
sudo cp $SRC/nginx/nginx.repo   /etc/yum.repos.d/
sudo yum update -y
sudo yum install nginx -y
sudo mv /etc/nginx/nginx.conf   /etc/nginx/nginx.conf.$(date +%s)
sudo cp $SRC/nginx/nginx.conf   /etc/nginx/
sudo cp $SRC/nginx/stratus.conf /etc/nginx/conf.d/
sudo chmod 644 /etc/nginx/nginx.conf
sudo chmod 644 /etc/nginx/conf.d/*
sudo touch /var/log/nginx/error.log
sudo touch /var/log/nginx/access.log
sudo openssl dhparam -out /etc/nginx/dhparam.pem 4096
sudo systemctl enable nginx
# Do not start nginx yet. Need certs for TLS in place first.

printf "========= Setup Postfix =================  ========\n"
sudo yum install -y cyrus-sasl-plain
sudo mkdir /etc/postfix/sasl
sudo mv /etc/aliases               /etc/aliases.$(date +%s)
sudo mv /etc/postfix/main.cf       /etc/postfix/main.cf.$(date +%s)
sudo cp $SRC/postfix/aliases       /etc/
sudo cp $SRC/postfix/main.cf       /etc/postfix/
sudo newaliases
# Start postfix in final_steps.sh

printf "========= Install Ansible =========================\n"
rm -Rf ~/.ansible
git clone https://github.com/ansible/ansible.git ~/.ansible --recursive
cd ~/.ansible
source ./hacking/env-setup
sudo easy_install pip
sudo pip install -r ./requirements.txt
cd ~/

printf "========= Install Redis ===========================\n"
wget -c http://download.redis.io/redis-stable.tar.gz
tar -xvzf redis-stable.tar.gz
cd redis-stable
make
make test
sudo make install

sudo adduser --system --no-create-home redis

sudo mkdir /etc/redis
sudo cp $SRC/redis/redis_*.conf     /etc/redis/
sudo chown redis:redis /etc/redis/*
sudo chmod 644 /etc/redis/*

sudo mkdir -p /var/redis/redis_stratus
sudo chown redis:redis /var/redis/redis_stratus
sudo chmod 770 /var/redis/redis_stratus

sudo cp $SRC/redis/40-redis.conf    /usr/lib/sysctl.d/
sudo chmod 644 /usr/lib/sysctl.d/40-redis.conf
sudo sysctl vm.overcommit_memory=1

sudo cp $SRC/redis/*.service        /etc/systemd/system/
sudo systemctl start redis_stratus
sudo systemctl enable redis_stratus
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

printf "========= Install Sidekiq          ================\n"
gem install sidekiq
cp $SRC/sidekiq/sidekiq.service /usr/lib/systemd/system/
sudo systemctl enable sidekiq
sudo systemctl start sidekiq

printf "========= Install OpenSSL =========================\n\n"
sudo yum install openssl -y

printf "========= Set useful openssl aliases ==========\n"
cat <<EOT >> ~/.bash_profile
# useful openssl aliases
alias cert='openssl x509 -noout -text -in'
alias req='openssl req -noout -text -in'
alias crl='openssl crl -noout -text -in'
EOT
source ~/.bash_profile

printf "========= Prepare CA dirs ==========\n"
# Prepare root CA directories in dir CA
mkdir -p CA && cd CA
mkdir -p certs newcerts crl private
chmod 700 private
touch index.txt
if [[ ! -e 'serial' ]]; then
  echo '1000' > serial
fi
if [[ ! -e 'crlnumber' ]]; then
  echo '1000' > crlnumber
fi
# Prepare intermediate CA directories in dir CA/intermediate
mkdir -p intermediate && cd intermediate
mkdir -p certs newcerts crl csr private
chmod 700 private
touch index.txt
if [[ ! -e 'serial' ]]; then
  echo '1000' > serial
fi
if [[ ! -e 'crlnumber' ]]; then
  echo '1000' > crlnumber
fi

printf "========= Place CA scripts ==========\n"
cp $SRC/openssl/prep_ca.sh              prep_ca.sh
cp $SRC/openssl/setup_rootca.sh         setup_rootca.sh
cp $SRC/openssl/setup_blacklakeca.sh    setup_blacklakeca.sh
cp $SRC/openssl/stratus_server_cert.sh  stratus_server_cert.sh
chmod +x *.sh

printf "========= Manual tasks that must be done ==========\n"
FIN='/vagrant/finalize'
cp $FIN/final_steps.sh         final_steps.sh
chmod +x final_steps.sh

read -r -d '' REMAINING_TASKS <<EOT
***************************************
Remaining Manual tasks:
From the host:
  vagrant ssh

From /home/vagrant on vm:
  gapppass=<google app passwrd> ./start_postfix.sh
  ./setup_rootca.sh
  ./setup_blacklakeca.sh

  ipaddr=$(ip route get 8.8.8.8 | awk '{print $7}')
  SUBJ_IP=$ipaddr ./stratus_server_cert.sh

  ./final_steps.sh

  This will:
    1. Set Google App Password for postfix
    2. Setup the self signed root CA
    3. Setup the blacklake intermediate CA
    4. Create the stratus server cert
    5. Copy certs from CA/ to cirrus/config/certs/
    6. (Re)start nginx
    7. Start the Rails app
    8. Restart ssh server to use hardened configuration


Finally add cacert.pem to trusted root certs:
  Currently certs are in: Libraries/Projects/ansible/cirrus/config/certs/
  - Windows:
      1. Chrome and IE
            Use mmc (Start > mmc > enter)
      2. Firefox
            Options > Privacy and Security > View Certificates >
            Authorities tab > Import > cirrus/config/certs/rootca.cert.pem
            && stratusca.cert.pem
EOT

echo "$REMAINING_TASKS"
