#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run as root
printf "\n========= Setup iptables logging ====================\n"
touch /var/log/iptables.log
touch /var/log/ip6tables.log
chmod 666 /var/log/iptables.log
chmod 666 /var/log/ip6tables.log

cp $SRC/iptables/rsyslog.conf   \
   /etc/rsyslog.d/20-iptables.conf -fb --suffix=.$(date +%s)
cp $SRC/iptables/logrotate.conf \
   /etc/logrotate.d/iptables       -fb --suffix=.$(date +%s)
chmod 644 /etc/rsyslog.d/20-iptables.conf
chmod 644 /etc/logrotate.d/iptables
systemctl restart rsyslog

printf "\n========= Install iptables ==========================\n"
yum install iptables-services -y

printf "\n========= Insert iptables rules =====================\n"
cp $SRC/iptables/rules4.sh    \
   iptables_rules4.sh  -fb --suffix=.$(date +%s)
touch /var/log/iptables_rules_install.log
chmod 755 iptables_rules4.sh
chmod 666 /var/log/iptables_rules_install.log
./iptables_rules4.sh >> /var/log/iptables_rules_install.log

printf "\n========= Insert ip6tables rules ====================\n"
cp $SRC/iptables/rules6.sh    \
   iptables_rules6.sh  -fb --suffix=.$(date +%s)
touch /var/log/ip6tables_rules_install.log
chmod 755 iptables_rules6.sh
chmod 666 /var/log/ip6tables_rules_install.log
./iptables_rules6.sh >> /var/log/ip6tables_rules_install.log

# Cleanup home dir
if [[ ! -e ~/bkup ]]; then
  mkdir ~/bkup
fi
mv  *.sh.* ~/bkup/
