#!/usr/bin/env bash
SRC='/vagrant/client_files'

printf "========= Setup iptables logging ==================\n\n"
touch /var/log/iptables.log
cp $SRC/iptables/rsyslog.conf   /etc/rsyslog.d/20-iptables.conf -fb --suffix=.$(date +%s)
cp $SRC/iptables/logrotate.conf /etc/logrotate.d/iptables       -fb --suffix=.$(date +%s)
chmod 666 /var/log/iptables.log
chmod 644 /etc/rsyslog.d/20-iptables.conf
chmod 644 /etc/logrotate.d/iptables
systemctl restart rsyslog

printf "========= Install iptables and rules ================\n"
yum install iptables-services -y
cp $SRC/iptables/rules.sh iptables_rules.sh  -fb --suffix=.$(date +%s)
touch /var/log/iptables_rules_install.log
chmod 755 iptables_rules.sh
chmod 666 /var/log/iptables_rules_install.log
./iptables_rules.sh >> /var/log/iptables_rules_install.log

printf "========= Stop firewalld & Start iptables============\n"
systemctl stop firewalld
systemctl start iptables
systemctl enable iptables
systemctl disable firewalld
systemctl mask firewalld
