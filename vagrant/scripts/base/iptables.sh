#!/usr/bin/env bash
source /vagrant/vagrant/bash_fns.sh

SRC='/vagrant/client_files'
BKUP='/home/vagrant/bkup'
DATE="$(date +%s)"

# Run as root
printf "\n========= Setup iptables logging ====================\n"
touch /var/log/iptables.log
touch /var/log/ip6tables.log
chmod 666 /var/log/iptables.log
chmod 666 /var/log/ip6tables.log

cp $SRC/iptables/rsyslog.conf   \
   /etc/rsyslog.d/20-iptables.conf -fb --suffix=.$DATE
cp $SRC/iptables/logrotate.conf \
   /etc/logrotate.d/iptables       -fb --suffix=.$DATE
chmod 644 /etc/rsyslog.d/20-iptables.conf
chmod 644 /etc/logrotate.d/iptables
systemctl restart rsyslog

printf "\n========= Install iptables ==========================\n"
yum install iptables-services -y

printf "\n========= Insert iptables rules =====================\n"
cp $SRC/iptables/rules4.sh    \
   iptables_rules4.sh  -fb --suffix=.$DATE
touch /var/log/iptables_rules_install.log
chmod 755 iptables_rules4.sh
chmod 666 /var/log/iptables_rules_install.log
./iptables_rules4.sh >> /var/log/iptables_rules_install.log

printf "\n========= Insert ip6tables rules ====================\n"
cp $SRC/iptables/rules6.sh    \
   iptables_rules6.sh  -fb --suffix=.$DATE
touch /var/log/ip6tables_rules_install.log
chmod 755 iptables_rules6.sh
chmod 666 /var/log/ip6tables_rules_install.log
./iptables_rules6.sh >> /var/log/ip6tables_rules_install.log

# Cleanup home dir
move2bkup -b $BKUP -- iptables_rules4.sh.$DATE \
                      iptables_rules6.sh.$DATE
