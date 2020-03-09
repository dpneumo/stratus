#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run as root
printf "\n========= Reload SSH server =======================\n"
systemctl reload sshd.service

printf "========= Restart Postfix =========================\n"
systemctl restart postfix

printf "========= Restart Nginx ===========================\n"
systemctl restart nginx
systemctl enable nginx

printf "========= Restart Redis ===========================\n"
systemctl restart redis_stratus
systemctl enable redis_stratus

printf "========= Restart Sidekiq =========================\n"
systemctl restart sidekiq
systemctl enable sidekiq

printf "========= Stop firewalld ============================\n"
systemctl stop firewalld
systemctl disable firewalld
systemctl mask firewalld

printf "========= Start iptables ============================\n"
systemctl start iptables
systemctl enable iptables


printf "========= Restart Fail2Ban ========================\n"
# Don't start fail2ban until all else is working
#systemctl restart fail2ban
#systemctl enable fail2ban

