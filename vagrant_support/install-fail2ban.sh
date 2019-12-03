#!/usr/bin/env bash
SRC='/vagrant/client_files'

printf "========= Install Fail2Ban ==========================\n"
yum install fail2ban -y

cp $SRC/fail2ban/fail2ban.local   /etc/fail2ban/            -fb --suffix=.$(date +%s)
cp $SRC/fail2ban/jail.local       /etc/fail2ban/            -fb --suffix=.$(date +%s)
cp $SRC/fail2ban/jail.d/*.local   /etc/fail2ban/jail.d/     -fb --suffix=.$(date +%s)
cp $SRC/fail2ban/filter.d/*.local /etc/fail2ban/filter.d/   -fb --suffix=.$(date +%s)
cp $SRC/fail2ban/gen_badbots      /etc/fail2ban/gen_badbots -fb --suffix=.$(date +%s)

chmod 644 /etc/fail2ban/fail2ban.local
chmod 644 /etc/fail2ban/jail.local
chmod 644 /etc/fail2ban/jail.d/*
chmod 644 /etc/fail2ban/filter.d/*
chmod 755 /etc/fail2ban/gen_badbots
/etc/fail2ban/gen_badbots

if [[ -e /etc/fail2ban/00-firewalld.conf ]]; then
  rm /etc/fail2ban/jail.d/00-firewalld.conf
fi

# Don't start fail2ban until all else is working
#systemctl start fail2ban
#systemctl enable fail2ban
