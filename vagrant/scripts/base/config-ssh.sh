#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run as root
printf "\n========= Configure ssh ===========================\n"
# See https://stribika.github.io/2015/01/04/secure-secure-shell.html
cd /home/vagrant/.ssh

cp $SRC/ssh/sshd_config /etc/ssh/ -fb --suffix=.$(date +%s)
cp $SRC/ssh/ssh_config  /etc/ssh/ -fb --suffix=.$(date +%s)
cp /etc/ssh/moduli      /etc/ssh/moduli.$(date +%s)
awk '$5 > 2000' /etc/ssh/moduli > /etc/ssh/moduli

touch known_hosts
touch authorized_keys

# We should not over write an existing key pair here!
if [[ ! -f id_rsa ]]; then
  ssh-keygen -f id_rsa -t rsa -N ''
else
  echo "Key pair (id_rsa) already exists. Did not replace.\n"
fi

chown vagrant:vagrant known_hosts       \
                      authorized_keys   \
                      id_rsa            \
                      id_rsa.pub

chmod 644 known_hosts                   \
          authorized_keys               \
          id_rsa.pub

chmod 600 id_rsa                        \
          /etc/ssh/sshd_config

cd /home/vagrant
