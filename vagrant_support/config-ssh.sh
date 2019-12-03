#!/usr/bin/env bash
SRC='/vagrant/client_files'

printf "========= ssh files ===============================\n"
# See https://stribika.github.io/2015/01/04/secure-secure-shell.html
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sudo cp /etc/ssh/moduli /etc/ssh/moduli.$(date +%s)
sudo awk '$5 > 2000' /etc/ssh/moduli > "${HOME}/moduli"
sudo mv "${HOME}/moduli" /etc/ssh/moduli
sudo cp $SRC/ssh/sshd_config       /etc/ssh/ -fb --suffix=.$(date +%s)
sudo cp $SRC/ssh/ssh_config        /etc/ssh/ -fb --suffix=.$(date +%s)
touch ~/.ssh/known_hosts
touch ~/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/id_rsa      /etc/ssh/sshd_config
sudo chmod 644 ~/.ssh/id_rsa.pub ~/.ssh/known_hosts ~/.ssh/authorized_keys
